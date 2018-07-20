require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-6.1.2.tgz"
  sha256 "8178ba4944ec4bdd889f512c75757b4957a849cd1a25a156c6a4590c6f51daaa"

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
