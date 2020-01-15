require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.7.1.tgz"
  sha256 "707dc14d86e5f2ef70bfd3821fde4dbcee9c26b2b6f6b88e125336b3d432077a"

  bottle do
    sha256 "edea46bdeb06d11e969342f353fa680d17a94067f18c6c98b7895b759a5a9b21" => :catalina
    sha256 "780f55f2dfc7b2b1d74ea0a57688977c9860a3dedfaead93c7c50e1ce5d9195d" => :mojave
    sha256 "b0407e6bd125fd95d466f51b40c60f9367ac404a10fa2f96637816dfc0c5e867" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
