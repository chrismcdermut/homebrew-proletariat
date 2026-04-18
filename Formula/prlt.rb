class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.122.tgz"
  sha256 "0034e6c70e75de3fbad4de2a6ba19886af6aad8d9d515fe6b9bd1c0ba0f2410b"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["\#{libexec}/bin/*"]
  end

  def post_install
    # Homebrew's std_npm_args uses --ignore-scripts, which skips better-sqlite3's
    # native module compilation. Rebuild it against the Node currently on PATH
    # (which may be the user's nvm/fnm Node rather than Homebrew's).
    cd libexec/"lib/node_modules/@proletariat/cli" do
      system "npm", "rebuild", "better-sqlite3"
    end
  end

  def caveats
    <<~EOS
      If you switch Node versions (e.g. via nvm or fnm), prlt will
      automatically rebuild its native modules on the next run.

      To manually rebuild:
        cd \#{libexec}/lib/node_modules/@proletariat/cli && npm rebuild better-sqlite3
    EOS
  end

  test do
    assert_match version.to_s, shell_output("\#{bin}/prlt --version")
    # Verify better-sqlite3 native module works by creating an HQ (uses SQLite)
    assert_match '"success": true', shell_output("\#{bin}/prlt new --json --name test-hq --no-pmo")
  end
end
