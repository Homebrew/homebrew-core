require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.22.0.tar.gz"
  sha256 "3c8b3c1bff0265d209820aa5199bd3471e458f19908721a89c1350fc7a426e28"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "d69b1214efdd59a64de79087ce7e88848d95dbbcd9cfbd9d53552232f60061e5"
    sha256 big_sur:       "6655bc381b9800459061209348fad1a84795a9f88364481365ca5a01125ece77"
    sha256 catalina:      "2ec4b92e20f646e38695e7448d537885e6df52c031f7d3e4fb24dce2f8e3e3d4"
    sha256 mojave:        "f5ac50d77b1bd2ff657eeb1a089fa8e9541d07a4ef36d25452833991aeab19fb"
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
