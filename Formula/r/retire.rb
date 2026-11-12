class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-6.1.1.tgz"
  sha256 "810b0c9099d8d1d8864549192e80bff5cd868f1ea0cbe4b2d3eb9a10d68d99de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67afaa51d72937a2c11b8166951f6d623e875d03ce657b8eaa74d049802e05ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
