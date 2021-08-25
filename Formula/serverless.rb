require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.56.0.tar.gz"
  sha256 "dea4e9e12ed8413e4ca42c3456e3b6c3400e14652b969fdb268b651d2319f5c7"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e99dda4e344aa5cfdc601f2c10997f9c0e4d55ae3ae813daf053cf1b66bafa21"
    sha256 big_sur:       "e24f2e5c6b09b36db415d1f1681400a4f7865be5624f2ff494e50c175cd2bf33"
    sha256 catalina:      "3424e15e6cdcf93221d4d143fbbbd351ffcab921b5e3c74c62e9afc189899033"
    sha256 mojave:        "0fb44993c902ef0793ed3be532425809f9bcdf672e4165a5e3129d5003682499"
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
