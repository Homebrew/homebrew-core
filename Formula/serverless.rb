require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.0.tar.gz"
  sha256 "58f0d3cd58c0aef9b79b77edabfc93cd99f847fabbf04ba77e0cdca6089b4883"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78578367f79e3505378425fac797c1c1ee0dbe37dcb338ddd81743ee752295b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78578367f79e3505378425fac797c1c1ee0dbe37dcb338ddd81743ee752295b5"
    sha256 cellar: :any_skip_relocation, monterey:       "0daa4716b61d51d591c7b22a93aceda624895c94aed605f125669d304a19f0e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0daa4716b61d51d591c7b22a93aceda624895c94aed605f125669d304a19f0e6"
    sha256 cellar: :any_skip_relocation, catalina:       "0daa4716b61d51d591c7b22a93aceda624895c94aed605f125669d304a19f0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c32216a4dbbad5b03a29614132bc362b4424f22f1fd80993d4e07d0f2e38a1"
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
