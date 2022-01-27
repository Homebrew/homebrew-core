require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.0.0.tar.gz"
  sha256 "89785f75308550c5160848783d5d0958a828559f16bc2d9790b388b32d0940b1"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "f4623ce845981fe19dc1867ff84dad97e8fc1af37141bfaefd942bbeaaa378ad"
    sha256                               arm64_big_sur:  "2d32089d9a7101ec1913d84e3d305703e7c1bb081efba29378100b46a43aec1d"
    sha256                               monterey:       "4105b7057e287f9c5c71ad98ef646215f322daefbd7c575eb34a87c41a15f74a"
    sha256                               big_sur:        "fa296ecb44d7e5fa60fb8590b325da545810b6507e0e34147396f0ec5eff6980"
    sha256                               catalina:       "fe3016308ee5ed9075a66a7449f510806e2fedc717c2911768434755539b0b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74acb66c8bb8ece43b0b01a490279a233c07f277d07e3cc328edb00c2af9fdc1"
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
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
