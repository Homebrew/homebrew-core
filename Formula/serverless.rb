require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.69.1.tar.gz"
  sha256 "bf577f2b4cf3495964884c0598f10e09beda57e092756ed1cc76862dc5c0ada0"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "d952f9cc3178c6d311af2d62e78b1fcf4af5b54891088efd5657568ec5b7b7c1"
    sha256                               arm64_big_sur:  "45b3b0068525c9ee3dee5aad1546276ee3fbafa69b1ae3bac42ba8518ba2f47a"
    sha256                               monterey:       "dac2ec2586bde0fe62281487f97c1747dbd778eb8f67872ab65c74d14deaffce"
    sha256                               big_sur:        "7a3057b377cebfe94e009f8ff84a54bc442a56ac75c0b4bd0ba482995c9363f3"
    sha256                               catalina:       "359f76790ee09716a5c1742a662078c046ba03a31a14c1ab6063af0eacfc5056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc95e3b195a446656ef7aff5a35704078d007115d6d5dd61148dd95804b95ee4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")
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
