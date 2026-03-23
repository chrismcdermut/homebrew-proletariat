class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.91.tgz"
  sha256 "1fffb7b0ce2069b34fcf48ce8fa9cb9fab4c5ccdd4791cdaebfd33825dc070e9"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prlt --version")
    # Verify sql.js WASM SQLite works by creating an HQ
    assert_match '"success": true', shell_output("#{bin}/prlt new --json --name test-hq --no-pmo")
  end
end
