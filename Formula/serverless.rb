require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.70.1.tar.gz"
  sha256 "e2907a7ef91c6ed6127ebe9d5d4e01ec04483e87c1d05a15e1baac96868198c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbc9658c231e26c473a0a756ba20736b868e666a62155ab60e3782b5e6e4c14a" => :catalina
    sha256 "54368e529d9bbefd2e717d9eea5f16739314f824282f07e23e2b9b0eec045cc4" => :mojave
    sha256 "a9e66d154c58778bcd75c174755dd8e813a75be8448fe052529c5e6f5ae492d3" => :high_sierra
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
