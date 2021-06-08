require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.45.1.tar.gz"
  sha256 "3d11688e9675aec143b73accfbf0fc48471b39b03b8741511ac4452f904b389a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "eff2c94b3d948a651a40cdedb5a65397e2d629bf44705f48bc5cdb83bf0e7911"
    sha256 big_sur:       "9a3524cbd3980d8213a0220632cdb96a4fce00646652e6962488a8c48ee9dfd4"
    sha256 catalina:      "ddcdd29a99e5d03b807904a1aa6f5e2ee11368bcb8ab642486c75a307c666afd"
    sha256 mojave:        "a6005f40b398b523cfbac4df7d4b9df53c5355d32c0c486a4afdbee2dc45dd55"
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
