require "language/node"

class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https://github.com/btford/write-good"
  url "https://github.com/btford/write-good/archive/v0.10.0.tar.gz"
  sha256 "1800b456b8838b98045192aed1fe51255282007786a211141de4db7f70d5e13c"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f6749a00f73e664eac44c6385fe5022947ef5c2156dfd762fb3ecb5c2eb284" => :catalina
    sha256 "c9793f3718f3fb1e3ff668427e62356825b60c263dd4a8db60b3e437bcb8cdde" => :mojave
    sha256 "9f8ad372e5eeb289fdb436c64c17cf69b360f18a0442c1eec3a6c01672f413ee" => :high_sierra
    sha256 "24e7a9e9bd36b2b42760876bfacd3eb1a963291cf8ec19a4f4569358bba3c578" => :sierra
    sha256 "5e184f772e79b219537e6bb327c73b2e64506754a1fa7b64f19cca1695dcdd41" => :el_capitan
    sha256 "37d206e7ac96493aa2cfb2424dc62f75765ae509f66fac44b6472e74ee02f4e7" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}/write-good test.txt", 2)
  end
end
