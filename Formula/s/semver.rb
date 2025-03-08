class Semver < Formula
  desc "Semantic version parser for node (the one npm uses)"
  homepage "https://github.com/npm/node-semver"
  url "https://github.com/npm/node-semver/archive/refs/tags/v7.7.1.tar.gz"
  sha256 "c6fee501b3391d48774bde7c57ffe222fc8744191bd5b9a42ec2fb8cc8150e84"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81375e351dab131d376193b01f54a96b2e30cbd18ff158c536f1932bf574f002"
  end
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semver --help")
    assert_match "1.2.3", shell_output("#{bin}/semver 1.2.3-beta.1 -i release")
  end
end
