require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.45.1.tar.gz"
  sha256 "c57cab8b1a9ba404ee4a3fc75d55a3ea1389da29f0b7b8ca0e4da39a5619c0ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "98c41b754a663c56fca28f65b7d0ae07cb02b81221feabeeb03597172ec4f67c" => :mojave
    sha256 "bd8523a94530b622aa974deed57f2c1bdbebafda7b81c0b0575c6f064343f35b" => :high_sierra
    sha256 "58e6059b40b82dd8292bf6019081c7b8e41cbbed7d91053f6d30c0652208cd25" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
