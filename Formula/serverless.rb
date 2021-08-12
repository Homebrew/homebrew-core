require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.53.1.tar.gz"
  sha256 "f817027538630147e43266e2b11a96cc24833a809a5886f4b322a145f2cd0dd2"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "3d761c90d102173b1d8cfddcedae0ad46b85ae98a171e0e8184143508f65129f"
    sha256 big_sur:       "ab0e8af142131f3557bafc83f1ad242554cb123afd859c9e478162088516dcea"
    sha256 catalina:      "38e3137e769673261ea677bb9384c5c0047efabd4411c1b9ccfec9ecfaaf216f"
    sha256 mojave:        "cc58f7a60834115a9aa016aca4a85d689102aa5e850a1de16e6d2b2c64e3a024"
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
