require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.11.0.tar.gz"
  sha256 "5e6399f992d4aaa1fb928c10db73a1e614e23e9aa351dc2a45fd8e731928a396"
  license "MIT"

  bottle do
    sha256 "4e2998fc7d41d5e08ce315ac4cf2f13144cea8db0ba36a99c71533f85d9c5079" => :catalina
    sha256 "2b689fe405214e6fd93428c18175b222af415f439a8ce6a8be05a04bcc5cb0dd" => :mojave
    sha256 "a46fb152793a8847573dfbdc21bec322ff5a13ffd73ab39a71e3db0af47f8bd8" => :high_sierra
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
