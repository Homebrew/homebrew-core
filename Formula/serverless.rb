require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.10.2.tar.gz"
  sha256 "7c881255b6a4d196497d2fdb8d5265240924529102db9673ce432366da9f4cb4"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c536ff3b91034cdae4d4f264a543f346218a66656f977313deccc292cf057e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c536ff3b91034cdae4d4f264a543f346218a66656f977313deccc292cf057e1"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd714700bc13a20fafb0b59576dfba5dce7a68972e5af7ca455ae98577b32f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fd714700bc13a20fafb0b59576dfba5dce7a68972e5af7ca455ae98577b32f5"
    sha256 cellar: :any_skip_relocation, catalina:       "4fd714700bc13a20fafb0b59576dfba5dce7a68972e5af7ca455ae98577b32f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd100492c3ab52ba4a8b06548fd04071f2f7b97f00ad5349569f5a1a9fba9b1c"
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
