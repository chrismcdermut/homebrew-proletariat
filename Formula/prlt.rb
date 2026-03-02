class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.48.tgz"
  sha256 "c4a7336c1823408d9aca23f75038c1dcf7cf03e4ca8edb84055f1055f99c5dd5"
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
    assert_match '"success": true', shell_output("#{bin}/prlt init --json --name test-hq --no-pmo")
  end
end
