require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.24.0.tar.gz"
  sha256 "55df053001f5d2ab6c0d6bb0cc86eb58b88c077153c756b1858b669fbb950e67"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b009b336e297b9ade60479ef070fae6f7b67d7ab2dc0168c6418b5f8a94db5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a9e8c6ac85f6b46c50884526e8adbe4135d2bcc6a0ab5acf0f17a194b34be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a9e8c6ac85f6b46c50884526e8adbe4135d2bcc6a0ab5acf0f17a194b34be5"
    sha256 cellar: :any_skip_relocation, monterey:       "e658ca5841dcae1d2f7c31cbda6c91dacf163dfe83d84e3012bbe2792c6ed99c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e658ca5841dcae1d2f7c31cbda6c91dacf163dfe83d84e3012bbe2792c6ed99c"
    sha256 cellar: :any_skip_relocation, catalina:       "e658ca5841dcae1d2f7c31cbda6c91dacf163dfe83d84e3012bbe2792c6ed99c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76872204db9209a4aae0fd240c59798032f8c94557c237d79d899b31e09cc82"
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
