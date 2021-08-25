require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.56.0.tar.gz"
  sha256 "dea4e9e12ed8413e4ca42c3456e3b6c3400e14652b969fdb268b651d2319f5c7"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "ee5fafb6782872bc0afd6ba3f520795cf59b746b17337b18588d8c3b6c03ed51"
    sha256 big_sur:       "503c6e0db1269cf85fe7e27a36f96a098ab0553329668cb61fefbb57927f8ffa"
    sha256 catalina:      "600891b74cda21ef5ae4731aa10924272a1d9dc42755b62bca48269b7bc9d537"
    sha256 mojave:        "7eeef2e37800cf030e49c03ee3037ba5120b1a55779e6f72cd0ed36d2955e481"
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
