require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.54.0.tar.gz"
  sha256 "387458ea2cf5acb4d3ad59698dd2c6fb08a6db85cd36acf7232de51e168f0e8c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a53ce38b634137adc7d8e8880080128b8365b8a88646e61c0706dde205951359"
    sha256 big_sur:       "89a4fbff843d4167873b820f20e8a3692bca47442a970119fc85b0eb6826bfe6"
    sha256 catalina:      "f6e3d731a8d46f56498c4ae368f4c65f928d70325359e04046d8badf7ddf584b"
    sha256 mojave:        "8d4458ce129683e8e5ef4e291c21a051004b912b691764576540c9743a585941"
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
