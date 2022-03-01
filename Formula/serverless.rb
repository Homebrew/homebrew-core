require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.5.1.tar.gz"
  sha256 "9d0474fa6fd74b7428167a764fd32cc85ea52c82dfd9f1b0166a41f4b15cabcc"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6807f83911828c0f9e13a5e2f887a03867068b3d7b2f5e79b5a89b6c140c9c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6807f83911828c0f9e13a5e2f887a03867068b3d7b2f5e79b5a89b6c140c9c63"
    sha256 cellar: :any_skip_relocation, monterey:       "f3aaa4528416c8df530f0e9b374c5c470ac461ea6ae088a25c35b06a309fb506"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3aaa4528416c8df530f0e9b374c5c470ac461ea6ae088a25c35b06a309fb506"
    sha256 cellar: :any_skip_relocation, catalina:       "f3aaa4528416c8df530f0e9b374c5c470ac461ea6ae088a25c35b06a309fb506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59543c8495581eac2a2f452ed01504e2d54c3ab0c67b308ba01491c108e9e010"
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
