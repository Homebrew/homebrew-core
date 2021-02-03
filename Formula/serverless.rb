require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.21.1.tar.gz"
  sha256 "f436e9f14aad2d0b75a6b59498145e37c164eff908473c06ec79e0e42ce7941a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a8c0b6c21c38c092b1a8277498392006c36fae033b94049d8f215aaea2c74cdd"
    sha256 big_sur:       "72086b0835d6da395bca95b5ada3740dc069af3d99d3246216d65579cdba0fa3"
    sha256 catalina:      "a0f8055b8ed1c9ad65c09727b0616e80ca1f8028dc5514f451f65609db4b214d"
    sha256 mojave:        "3ee6d99b4aca2c48115a770a7af7551451457b1226a1a186af7e6f214771734f"
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
