class Prlt < Formula
  desc "Agent orchestration platform for AI labor"
  homepage "https://proletariat.ai/"
  url "https://registry.npmjs.org/@proletariat/cli/-/cli-0.3.42.tgz"
  sha256 "e4e62597196b5cc8321ca2941e3f25ca9ed0dde4a34403bbfaf75679b1bf0e11"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prlt --version")
  end
end
