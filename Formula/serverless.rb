require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.2.tar.gz"
  sha256 "aa4233650960d808aebaebaaf315c94a4dceef2e2b559271c4729676235d6f20"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca2e10add0adbd59d3c093cd251abbae310ec55dee7a88f095c596a790a0c5a" => :catalina
    sha256 "347959f0ba26b60f059b85d16c8aa57c16294b03b7a57641654082a8d43b5cc1" => :mojave
    sha256 "7b7e294686db11dd636561cafa99b5d727b1568031d8b315b16e0f6b7caefa6e" => :high_sierra
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
