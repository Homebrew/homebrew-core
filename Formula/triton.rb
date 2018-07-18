require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-6.1.1.tgz"
  sha256 "1489bef5fc1e43aae0600c2767122c14ebc5015745a52adc91d10cbebca8cd8a"

  bottle do
    sha256 "dff2adfb606119f4d3fcefcabc4e2b1e73783fbc357afc6eccd41a4d0599de5d" => :high_sierra
    sha256 "8f654575429e7f236a2135aa5e909ceefce958ea209de986d4cfb5f5324e02ce" => :sierra
    sha256 "3c9560f04c445b6cbf93ae2c816363a8673190fdd28908d7e459547236f23ffb" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
