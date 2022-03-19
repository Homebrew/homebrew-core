require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.9.tar.gz"
  sha256 "0e31e072f712a63d7e5131750fa84973122587680ff241ed1afc1be5a782c48e"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e9b3739deb83570a73efb7120131303fcc72184e6a28b1bad351b9e808ee7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e9b3739deb83570a73efb7120131303fcc72184e6a28b1bad351b9e808ee7c"
    sha256 cellar: :any_skip_relocation, monterey:       "3777c95dddbd57294fb7c306f7deaa9311f252680590a320a2fdef9db1c78062"
    sha256 cellar: :any_skip_relocation, big_sur:        "3777c95dddbd57294fb7c306f7deaa9311f252680590a320a2fdef9db1c78062"
    sha256 cellar: :any_skip_relocation, catalina:       "3777c95dddbd57294fb7c306f7deaa9311f252680590a320a2fdef9db1c78062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f91eb09c0d1b7670907fb34318665d82f88a742309170890bf3e41429df5f0"
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
