require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.10.2.tar.gz"
  sha256 "7c881255b6a4d196497d2fdb8d5265240924529102db9673ce432366da9f4cb4"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f01ae73da30bffd292dc7b2649c95007ed0fbae6dd2a4eed9cefae01c7a8866e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f01ae73da30bffd292dc7b2649c95007ed0fbae6dd2a4eed9cefae01c7a8866e"
    sha256 cellar: :any_skip_relocation, monterey:       "7778b90b9e1f08dfbb70dbcac74603c42791000fd8d91e8361b84f1b63d72d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7778b90b9e1f08dfbb70dbcac74603c42791000fd8d91e8361b84f1b63d72d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "7778b90b9e1f08dfbb70dbcac74603c42791000fd8d91e8361b84f1b63d72d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea6e62d81fe5b9e4b626b250c46cf9069a2922bfb073da48840cf06cef9c55b"
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
