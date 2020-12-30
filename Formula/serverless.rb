require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.17.0.tar.gz"
  sha256 "b04c0064191a823f7381f61bc2e4b91efb007d2f6344423a2744e8a85a80ba9b"
  license "MIT"

  bottle do
    sha256 "a0659cfde7d73e4bd859c37191b9b003b3bf633e62d1ae8d1b0f6fd8cd6810f0" => :big_sur
    sha256 "869a060c419713bbf78d078418b53079be523068a34450caf75df1fec701c64b" => :arm64_big_sur
    sha256 "de78d07871e8d7aca35def658da29a079c20a19c08a5b4632e619c5b4c3191a1" => :catalina
    sha256 "e5eb7a13334512d5b8695160f63064e54cefaca9183216f5372f065a55f4f45d" => :mojave
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
