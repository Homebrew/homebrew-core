require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.25.2.tar.gz"
  sha256 "d75e4902e3a1a45685b0168ec43a9cab219026a332c1f874f555662b61ac5706"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6223f98c6b4ceb67b919b0e4d0a649c8e2e32cab6f9fa1333dfdbaeeb3522b00"
    sha256 big_sur:       "a111577fa0db3bcf4f1f2b61e7b4a36cb6beceea9f3f7bebca4472cd21c306bc"
    sha256 catalina:      "b5f31a3a38e7ca2866d90f47b9bfdb3f08a64480cc4de50514f54c8835a8e3f4"
    sha256 mojave:        "e11c8113db7444014f309d6cd4724fde14d3aefd634ea9fdad06f6e9d0b8625d"
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
