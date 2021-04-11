require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.35.0.tar.gz"
  sha256 "2267912fcb3180fe559b38bc838577d7ea4dca5c8f62b1be4a3191694de70236"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "0a7c9ae7db3ab81e55df03349a795069b9ee8a19e8ec1610ef353a60f4c46cbe"
    sha256 big_sur:       "63ac961d1b9fda79d895ecb179476c792287d672d123a08f1f608ec4bbbec736"
    sha256 catalina:      "10bbb2d77fc64edee4558ed945c915825c4d465a4bd2919b205a46858ad03f82"
    sha256 mojave:        "3f7d1a61c47002409328cdd6e19ca8959f5b6f7e1e3a72e4db3d864dcfd95ee8"
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
