require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.7.0.tar.gz"
  sha256 "036bf45c778295095ce12edeae6218d6ec02c771947a607bc434ca0054a65168"
  license "MIT"

  bottle do
    sha256 "3de12a584862a090e5a9caaf3b8091799671595a17d78a407e2fe652ccde16e8" => :catalina
    sha256 "942eae642a2a2a0077641465a9f6d09913bb4bc7676cefab2f5cf26f9fa9e8f1" => :mojave
    sha256 "29ddf00686e81211ea6255da65f76899a1b021e62da0492ddcef78e183d8fea0" => :high_sierra
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
