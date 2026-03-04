class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.52.tgz"
  sha256 "59fec69379302b5da3d1c8570a4e7ac7350b5d415ee6f200fd07844cd0e0c30b"
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
