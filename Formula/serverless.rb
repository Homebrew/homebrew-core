require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.53.0.tar.gz"
  sha256 "736f6a1fad05f18bd3e40adc2b1b62965e294f6b62bbd25f41c415025aa8dfe4"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "4603b7b2e0719e5407ec43ef64d08169eb5f295c53038af6749e992ca41eaecc"
    sha256 big_sur:       "850600635b63b24e664db1622d67b0918ce18b9af8954de09bcc4ef0838931e2"
    sha256 catalina:      "51d47f2c7aa23545c8c8c35acf31629ad3573ff9265b566c9ecc4d551d4a86c8"
    sha256 mojave:        "a922be5f4fdae6ff56738aa4137830d9b98d00e98e1ea0cbd1f061f8710712f8"
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
