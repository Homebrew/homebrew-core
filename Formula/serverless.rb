require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.61.1.tar.gz"
  sha256 "cf2441afc743effebdf7f2ef8471e504414a4cdf9d3c5a8ba51313b6c059ec09"

  bottle do
    cellar :any_skip_relocation
    sha256 "391173b1d0c311828ffff3fd4c629da833f47e04e17002af77ed5f02a5350b9c" => :catalina
    sha256 "368a47a8f1f969302a562fa92782f7ea54b99103581c2b74467f70bf383344b1" => :mojave
    sha256 "596a3b3c3157dd25d213431dac74ba427e208f3324a57eafc724dd2cc2a43b89" => :high_sierra
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
