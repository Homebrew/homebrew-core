require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.13.0.tar.gz"
  sha256 "5ddd9e2d85ea1f3defafb54ba29ab42ec6edcb73e642a5684ccf7522281fef10"
  license "MIT"

  bottle do
    sha256 "15ad4a52c6324552d8f41ac4ec06e138c19333ce55e9df5e01f88acbcea30b2d" => :big_sur
    sha256 "a26964b5018673eef05f0d3143dc163661a15a01e34f37b6610c6acc01c62b5a" => :catalina
    sha256 "1aa4f5400496832a935ddbca7570ac1b3a19279ab00b01aba73a52bdefed828a" => :mojave
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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
