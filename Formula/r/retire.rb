class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.2.6.tgz"
  sha256 "d0403aeff13610ea499326813a043b789c72c680f8825c08cab961e7103f0008"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dc92e4f27cc38384252c412f32efff290168defe2dc8ed29d5764284ae764aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
