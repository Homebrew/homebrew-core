require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.1.1.tgz"
  sha256 "24a1f697ee71451893f108dba9e4a5a7830cefe22028d98b504b3d2fe65ab2fe"

  bottle do
    sha256 "d922bbc986d99360e1e6eabb2db1d62522cbbe602917d6c4fc4b92b90bb0a511" => :mojave
    sha256 "2ad12b954148047e979fb55c73b19cba2b09a4e8fafc7ccbc2481584d64bab01" => :high_sierra
    sha256 "cf57768a0848d2ede75c71f00756df50d6ab7038b09f8fe2ba30746bb90e8b9f" => :sierra
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
