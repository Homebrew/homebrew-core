require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.30.1.tar.gz"
  sha256 "b75f16dd62faa348a0e082e62bd70ac8a9ef64179ff83c1f5bccc87b2a222a51"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceff19e2338c86d8b4e998ed8238958b7d6d8fd8e0986ece3f60939319956ef3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceff19e2338c86d8b4e998ed8238958b7d6d8fd8e0986ece3f60939319956ef3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceff19e2338c86d8b4e998ed8238958b7d6d8fd8e0986ece3f60939319956ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "3ba8435c86a1a2292deeeddd1977cad47804357715babe47f09e8e1a15ddcd16"
    sha256 cellar: :any_skip_relocation, monterey:       "3ba8435c86a1a2292deeeddd1977cad47804357715babe47f09e8e1a15ddcd16"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ba8435c86a1a2292deeeddd1977cad47804357715babe47f09e8e1a15ddcd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3a97e50eda328ce07d65c6d993e22186c8a511ae6269e5424201b578cee1b7"
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
