require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.2.1.tar.gz"
  sha256 "cc52ca47f8b6b836991e7c44efe6c3cabaf6acd0e7ddece57cbb0109367fbe36"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec63530a747e79d15c284b9cbdf0eb07deb2cb5329607bb608fe5b5b56f32393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec63530a747e79d15c284b9cbdf0eb07deb2cb5329607bb608fe5b5b56f32393"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d67c7f52bcbfc8a3050e0b292ad8cd3cd94ed43a8c4406b2a6f8f89e9749d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2d67c7f52bcbfc8a3050e0b292ad8cd3cd94ed43a8c4406b2a6f8f89e9749d3"
    sha256 cellar: :any_skip_relocation, catalina:       "f2d67c7f52bcbfc8a3050e0b292ad8cd3cd94ed43a8c4406b2a6f8f89e9749d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63793f1e1ce808bb4d051599830c3064d91d3091f67d6fe4eef6af8aed7a4c75"
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
