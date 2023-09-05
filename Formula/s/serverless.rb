require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.34.0.tar.gz"
  sha256 "9478e07693d60e741b10398f450723fe652eff372024d9066c4bcec839331b5a"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "728d75ba0690c51294b3d1ea4de9d2d0462072cc6dd07da384a4890dd1161c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728d75ba0690c51294b3d1ea4de9d2d0462072cc6dd07da384a4890dd1161c4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "728d75ba0690c51294b3d1ea4de9d2d0462072cc6dd07da384a4890dd1161c4f"
    sha256 cellar: :any_skip_relocation, ventura:        "f848f71a7a38dc1eccf334a1b717c009a9441cf16b1bd08fec9ceea4aef93c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "f848f71a7a38dc1eccf334a1b717c009a9441cf16b1bd08fec9ceea4aef93c0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f848f71a7a38dc1eccf334a1b717c009a9441cf16b1bd08fec9ceea4aef93c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e97314e36e3579ee2574bee9da52525a2fb0a5e185e70292f5feddd01d1b58"
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
