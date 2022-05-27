require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.18.2.tar.gz"
  sha256 "2b2d0722eb738cbcfda16c7cc2a15db2f0f12f905da92979633b813b2dbdfc3c"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "345c8ab3e2791740cc59aba2ebd68352a1b3bdcad017b631d3119ea07f75bcbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "345c8ab3e2791740cc59aba2ebd68352a1b3bdcad017b631d3119ea07f75bcbd"
    sha256 cellar: :any_skip_relocation, monterey:       "4c72ee07f4cf80b524e741512c87df15bb9c98ab68a6aec6540c976b74d5418f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c72ee07f4cf80b524e741512c87df15bb9c98ab68a6aec6540c976b74d5418f"
    sha256 cellar: :any_skip_relocation, catalina:       "4c72ee07f4cf80b524e741512c87df15bb9c98ab68a6aec6540c976b74d5418f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c90d839bbb704abbdb5f55b7d17a1ba8f0f948484b7bfb3a4caa5b0077f2af"
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
