require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.44.0.tar.gz"
  sha256 "f1418e66dd71719a3b10b09847437baa125529f0528d69195a83cd2256b568bf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "8f9fd07b1a551c4c0ecdf62c79433d55f50dc5da220e2afb1eea5f0cf342a119"
    sha256 big_sur:       "04319b1581895d50ea45240685f7f6a300e6851a0377620b63e240a18d4fc42c"
    sha256 catalina:      "43c2fc2b31b1b8e7bd58f2c6edfba1e0fed177af8dcfd7ce44cb1e2fd2fb488c"
    sha256 mojave:        "0701a7898436ceda469b1664babf7578834ea591a226a9d8766588c299942324"
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
