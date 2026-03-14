class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.62.tgz"
  sha256 "806afc7bc8313c8f659f86eace3c03e295be2f3dcd17ff1945a12e2f8da67ab6"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def post_install
    # Homebrew's std_npm_args uses --ignore-scripts, which skips better-sqlite3's
    # native module compilation. Rebuild it here so the CLI can use SQLite.
    cd libexec/"lib/node_modules/@proletariat/cli" do
      system "npm", "rebuild", "better-sqlite3"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prlt --version")
    # Verify better-sqlite3 native module works by creating an HQ (uses SQLite)
    assert_match '"success": true', shell_output("#{bin}/prlt new --json --name test-hq --no-pmo")
  end
end
