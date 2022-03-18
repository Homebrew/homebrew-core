require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.8.tar.gz"
  sha256 "ec0cb38e4a69f774d67864ee0c4cc8bb00b0da8eae78b9d31c13ba0a3415aca7"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5464e27827b8f7bb9eb67e52f976cd0e84d9506ac003927874c82432a917c3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5464e27827b8f7bb9eb67e52f976cd0e84d9506ac003927874c82432a917c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "3783d6b2c9f84b993ecbfa966975476c2c40129592185b141d698503a0f3731f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3783d6b2c9f84b993ecbfa966975476c2c40129592185b141d698503a0f3731f"
    sha256 cellar: :any_skip_relocation, catalina:       "3783d6b2c9f84b993ecbfa966975476c2c40129592185b141d698503a0f3731f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78682ed3b6869d5da4939a11b1ca04cea41c6ac4e44ef32de6ad9a1f588f088"
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
