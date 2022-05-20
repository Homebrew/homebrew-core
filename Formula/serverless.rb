require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.18.0.tar.gz"
  sha256 "9670d9c8cb6bac1c89b1dfdb08c1a36e8a45ba3e3def305f9112fae5771d6c8f"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df01b57f36da95a7baef444d107d8ae6e2bb0cccb591e87881251ec840a730a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df01b57f36da95a7baef444d107d8ae6e2bb0cccb591e87881251ec840a730a9"
    sha256 cellar: :any_skip_relocation, monterey:       "b30f10cfc18e59ebce459a10e3fa57ec63840b54f545afbf5323ea2c58ca5059"
    sha256 cellar: :any_skip_relocation, big_sur:        "b30f10cfc18e59ebce459a10e3fa57ec63840b54f545afbf5323ea2c58ca5059"
    sha256 cellar: :any_skip_relocation, catalina:       "b30f10cfc18e59ebce459a10e3fa57ec63840b54f545afbf5323ea2c58ca5059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e644e56f332ab4bfdeabab3ffe2e3798867e33c0dd32e660dcc0f7b4773d676a"
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
