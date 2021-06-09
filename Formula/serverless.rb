require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.45.2.tar.gz"
  sha256 "83ec3c133232f64fb60ca812a23d0e957d5650534bf7231330a1b7886db78660"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "3a170116bb5d9b25c4b171912eace4b4ff2ff22b6614b15cb94d51f7498479e3"
    sha256 big_sur:       "1fbb7ec451d4e1019d7aaf65fad82c61c315b956065b40246f7ffac00ec897c3"
    sha256 catalina:      "45e12077e9d201d323b123543474461295694df11fb456c6add8075c96c071d1"
    sha256 mojave:        "183558956f1dbe31c99ca7d1c610e0ebc0a2236333fde1a6b8dca50ee572e90f"
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
