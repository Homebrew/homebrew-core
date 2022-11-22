require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.25.0.tar.gz"
  sha256 "ecc1b402d26fd6153c78f18f85415efc060d02ab9252b5eda07cb659ead7fa33"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9a4c0bc716f5382ea888bdbc0ee1273a4f6833c4e7d96ea5e1b24c9b1e16d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9a4c0bc716f5382ea888bdbc0ee1273a4f6833c4e7d96ea5e1b24c9b1e16d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea9a4c0bc716f5382ea888bdbc0ee1273a4f6833c4e7d96ea5e1b24c9b1e16d8"
    sha256 cellar: :any_skip_relocation, ventura:        "2275f82e9b8a771c1652db3d51dc19d125d079b5bfd9763e7509aedaef108f80"
    sha256 cellar: :any_skip_relocation, monterey:       "2275f82e9b8a771c1652db3d51dc19d125d079b5bfd9763e7509aedaef108f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "2275f82e9b8a771c1652db3d51dc19d125d079b5bfd9763e7509aedaef108f80"
    sha256 cellar: :any_skip_relocation, catalina:       "2275f82e9b8a771c1652db3d51dc19d125d079b5bfd9763e7509aedaef108f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a701229390a2a989329afee4800269b64aadd3de519e7fc9153f3edb858d24"
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
