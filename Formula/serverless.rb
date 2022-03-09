require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.2.tar.gz"
  sha256 "2e94dc71e3b6970338be4012d2fa86b541b9a4ce535766a935390f96f5307a27"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e335d5e191c86ba748eb2c8658d4b4fb850cd05add000d5ae051214fd5d5784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e335d5e191c86ba748eb2c8658d4b4fb850cd05add000d5ae051214fd5d5784"
    sha256 cellar: :any_skip_relocation, monterey:       "dcab9b2e5a2298778e4ae82d85d6f325b62ff4842e9b7cb27843fa8461ce72c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcab9b2e5a2298778e4ae82d85d6f325b62ff4842e9b7cb27843fa8461ce72c2"
    sha256 cellar: :any_skip_relocation, catalina:       "dcab9b2e5a2298778e4ae82d85d6f325b62ff4842e9b7cb27843fa8461ce72c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e172c570f545fe2d293034ef2da0d853ad7d3ae51f620486ec36ee64df0cb323"
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
