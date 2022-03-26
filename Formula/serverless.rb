require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.10.0.tar.gz"
  sha256 "7fcd97effa4c6a89f8ac92b6a898175658ba26be75b553ca50d526e1cf39fef5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9620718ca658e2d5bd9ee95d7c96136396dc79ef687437373b1cbbbeade4a92e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9620718ca658e2d5bd9ee95d7c96136396dc79ef687437373b1cbbbeade4a92e"
    sha256 cellar: :any_skip_relocation, monterey:       "9c8f4c0d6bc8a6204ed9ae02cc33f67c4111702683c95c93d946960340b66363"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c8f4c0d6bc8a6204ed9ae02cc33f67c4111702683c95c93d946960340b66363"
    sha256 cellar: :any_skip_relocation, catalina:       "9c8f4c0d6bc8a6204ed9ae02cc33f67c4111702683c95c93d946960340b66363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca63096f3e0ad9aecd95a5f4f839c6441be3bd6e6408adb712323cf6efc9f8be"
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
