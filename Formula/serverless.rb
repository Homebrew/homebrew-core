require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.63.0.tar.gz"
  sha256 "7f0130fd062be64cda54de2d00f072a5b301a5f3f8fa1d9b7225ea4c1873790b"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "734d335c344f8d38e881d1b77896030f62474e49538f070edace82f73d40edbc"
    sha256                               big_sur:       "2e7f1ddf60d4a88aa60e522c4cd5556170c63d4a61bac1dfb3f44cc7fb51d145"
    sha256                               catalina:      "572ade49fc1f7916a2336321f963d1f8d4f44207447c4ccbd063a1dda0853536"
    sha256                               mojave:        "d5ac97db15da7c74a775d1422c7576415e5d59ed88077f5f3774ae13b1128a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e339e9dcfde4679ff5f2f7a223632f352a29774070b25fc7e88333f6e7b22314"
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
