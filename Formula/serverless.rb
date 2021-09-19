require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.59.0.tar.gz"
  sha256 "b2a222820b1cb02d35fad47000d94ebaef237ca2b574b0bbc1afaea41cb346aa"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "3e4939a7d55f05f67ba516017427564a9a926b0e557d9d03a3b10f1e60c1821a"
    sha256                               big_sur:       "07207e0292a471876d3848a69d987463adc3ec06a3cb7dfebfe4a0c9ee3bb3a1"
    sha256                               catalina:      "e7bf960adc2c705cd98e51b1fe9d48b376d519dac15c24b29a37b799ab09ed70"
    sha256                               mojave:        "183bdbe45aa0482967c0a7f384d399620542148a713fdc23b4bfe23a872fae53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6015db91814f1b4ad54a6c43d7d55028180dc900a84dad2cf4f33d68eb2391a8"
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
