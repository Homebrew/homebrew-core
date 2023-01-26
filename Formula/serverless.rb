require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.27.0.tar.gz"
  sha256 "62472b3ba2d124043c1ebaba8745dd27b5455da5b39dff292a4cf3c66d601b56"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df7cc5b234a81e81f1fa0485b8dd59f702b37f7df630b37fa351b4ff052c226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df7cc5b234a81e81f1fa0485b8dd59f702b37f7df630b37fa351b4ff052c226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3df7cc5b234a81e81f1fa0485b8dd59f702b37f7df630b37fa351b4ff052c226"
    sha256 cellar: :any_skip_relocation, ventura:        "6f855f541afb0e49853b58c209f9e58d30e5f358155e8fb13e67ae79303496b7"
    sha256 cellar: :any_skip_relocation, monterey:       "6f855f541afb0e49853b58c209f9e58d30e5f358155e8fb13e67ae79303496b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f855f541afb0e49853b58c209f9e58d30e5f358155e8fb13e67ae79303496b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1d8e98beead2a333ab1a6a4c96f99d16028c91c27d7a4ecc567332f8e5a0df"
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

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
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
