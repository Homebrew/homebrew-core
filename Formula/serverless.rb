require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.28.7.tar.gz"
  sha256 "3e1d9061ba5dd0a23e9754995838d9b01a5db860d2802fec2ca40105423ae1e4"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "b1ad42de6ac43f6f175dd8126733e1309b73c82b48d4cc1a52c719d9fcdbf71d"
    sha256 big_sur:       "811e21f29ff9d12fca0226171deb2e73e40cd4cb45163740f464131858250ef6"
    sha256 catalina:      "5601a2e234ef3e7586b6558841636ef20686f16f9ccebb0bdfa2fd22d80c7fd4"
    sha256 mojave:        "e9644208573bc7a673e30f12ab8f10c499ece9447e44c4dd84b6ef1d374229f2"
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
