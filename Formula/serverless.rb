require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.29.0.tar.gz"
  sha256 "413fe4571a50ce4335061c9b015993c7578cfc786e4185093806e8e8d1e69935"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fefb0db960110f9120c5b57449ae34cf13f1671ab3f58b1e95409f8436b3f536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fefb0db960110f9120c5b57449ae34cf13f1671ab3f58b1e95409f8436b3f536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefb0db960110f9120c5b57449ae34cf13f1671ab3f58b1e95409f8436b3f536"
    sha256 cellar: :any_skip_relocation, ventura:        "a88a44bada85609bf63d0a2462e05370ee0281cf6194da88781c6c8a0a9a7464"
    sha256 cellar: :any_skip_relocation, monterey:       "a88a44bada85609bf63d0a2462e05370ee0281cf6194da88781c6c8a0a9a7464"
    sha256 cellar: :any_skip_relocation, big_sur:        "a88a44bada85609bf63d0a2462e05370ee0281cf6194da88781c6c8a0a9a7464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73f0f0f43646a6ba31cb18453d59b9f3bfc837bc84bbc585cecf68d1189b7a53"
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
