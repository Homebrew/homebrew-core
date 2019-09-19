require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.52.1.tar.gz"
  sha256 "d98aaffe607970d994ee69285390e27ad7195f1ac028d5185d3e8c7876619ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c9e319e72190a393d2521b484def72394d9a35e46cb5b7db15071aea5dbd8ac" => :mojave
    sha256 "dd4a22560d6fe74f79e47b1031580633895860237f0189e0c7cb871d8f549f4d" => :high_sierra
    sha256 "b445013e66cacd5e78a6b4af376fcc0e96f224263b096773815fb0b6f0b33489" => :sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
