require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-6.1.1.tgz"
  sha256 "1489bef5fc1e43aae0600c2767122c14ebc5015745a52adc91d10cbebca8cd8a"

  bottle do
    sha256 "f2cf27b1732804300e82565710011031833475ab7709c8d9ff60dfd41745bae3" => :high_sierra
    sha256 "cdbd1a746652673f239c8e22968671d238386897cd876715d30fe95144f27d45" => :sierra
    sha256 "d9aa490c67b6f3b365a1dc4e27eb021c84a09a2f3c7f7ddba48f43ab6973cad7" => :el_capitan
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
