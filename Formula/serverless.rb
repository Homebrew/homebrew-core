require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.43.0.tar.gz"
  sha256 "a03a15f6a3cec6b7c9531b7bf7fc41b0357c91363676b08adab81f2ba1571791"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "85e97f1cbbf086b29a93c212fd16c3a54f101af2bdae6a19fbcc0f7ef4748b52"
    sha256 big_sur:       "810824364387271ab0d2a88df0f90a9195ae3cfc13070618a1aa4e521e4af7af"
    sha256 catalina:      "f0a9358237ec5773e3e4de7b62df6b1ccd2ede42ed5550fc87e43c0abd695e41"
    sha256 mojave:        "52625e2701a4226a9f81f72d555542d667a0009d81460c9990dfc227fbd6647c"
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
