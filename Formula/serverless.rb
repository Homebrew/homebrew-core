require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.29.0.tar.gz"
  sha256 "e8c7647373de8c102102ce34e0f2347c326ad58d05d652039de8550714a14a2a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "af940229422b613a1db9df97769b2a5501f7a7ddc5e0b472edc29cecdeb2246d"
    sha256 big_sur:       "30c5ad0dbb42aabdc13e5e4ff47234f5a417ad3d51e2ecee4538df18240bdd20"
    sha256 catalina:      "f1d1b5e4eb0b61104b5b0b40278b1586cf2e9560e87952a64ba5a5cd53cbd334"
    sha256 mojave:        "497828c8cfa88bfd03dfd805e966618342c1087bc0e6ab90a76f348e96677360"
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
