require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.37.0.tar.gz"
  sha256 "ad67b1e08095ce081357a476bc1935621da24a6fb07aac9decf75f1a3ce30e4c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "ea1d829376628b4d3b714adfadcdc77a4d1160838d2e51b663d2117dc73c4d05"
    sha256 big_sur:       "d92950b4f35c73026b52976050ef5f088e162f3a74d2e01a9c5a3ed4aebc5649"
    sha256 catalina:      "555f53e82362deaee9c3a83076764a1e52bfe262d98a38f5c955da3941266801"
    sha256 mojave:        "3962d43026e89f33c2a718d88ed46120fbfe0752db77dcb292da6110536cf79e"
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
