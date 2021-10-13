require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.62.0.tar.gz"
  sha256 "ab7e7cfe242c5b505288c8421a50e42f62dd8ebf757df4c7f5acbaeefab3cf2d"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "0a624db1e90d6b8e77458c0b8e93725ffc71741848c43153ef1edfa897e6c3ef"
    sha256                               big_sur:       "5bdc29b4eb129ab33d1d8910d8774ebf17066dd48927e1b61d17f94eae3d79a4"
    sha256                               catalina:      "78dba80d4d3cb80e083fcb75e6b1aa17e7c92ae91519e97074a8ef36a8adbd38"
    sha256                               mojave:        "c32cbc8b96aeb343e3d623c2bd3d8e941d24a77aa23d8007f5dcc1cf9d0969da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32b702dca1e6c44b7af010710aecc7a9a86caef44bb062d4e3080b895b847268"
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
