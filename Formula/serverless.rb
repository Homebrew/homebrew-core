require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.44.0.tar.gz"
  sha256 "f1418e66dd71719a3b10b09847437baa125529f0528d69195a83cd2256b568bf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e90b472e04510f17ef39a6a38a90f776e644896f03278c92593531b1bbba0fd2"
    sha256 big_sur:       "813d634ea6fec7de44681c4cd62cde3e6c639c50a772461f00d8e365be5848f3"
    sha256 catalina:      "59b2909dcaf7ab5c0f9ec90c532deb7f3b008fe880b332a04ddbb26b3f34d2ae"
    sha256 mojave:        "e620ca3b98c190ff61527fccebf0410a4499ef91c55dc5248adf7763bf45f470"
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
