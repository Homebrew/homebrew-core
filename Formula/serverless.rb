require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.26.0.tar.gz"
  sha256 "04c6307f1f59c6ca1ec951fa81f57ea1f80d2211ecca4a835ca5a9a6986ed39b"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da7f205e73cf735cf8ce3bd8bb911a26a898cf6b6d816d764038f42dc73679d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7f205e73cf735cf8ce3bd8bb911a26a898cf6b6d816d764038f42dc73679d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7f205e73cf735cf8ce3bd8bb911a26a898cf6b6d816d764038f42dc73679d4"
    sha256 cellar: :any_skip_relocation, ventura:        "17ba7e9e9a29b65947ef8e523b0f05ba0ffb21078790735ceafe0fa8d78298ad"
    sha256 cellar: :any_skip_relocation, monterey:       "17ba7e9e9a29b65947ef8e523b0f05ba0ffb21078790735ceafe0fa8d78298ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "17ba7e9e9a29b65947ef8e523b0f05ba0ffb21078790735ceafe0fa8d78298ad"
    sha256 cellar: :any_skip_relocation, catalina:       "17ba7e9e9a29b65947ef8e523b0f05ba0ffb21078790735ceafe0fa8d78298ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63e614367da6d97b86b598df17d264574eeb6191022112ce2da72d817d9f33d7"
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
