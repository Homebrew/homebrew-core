require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.28.0.tar.gz"
  sha256 "b668936db713e61ac891c38078c20687e9805f996e183d397cee56f96d9b0381"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c5d6c617b0b8f7cd72d00e7ec278b6f899adccc5cbc70291d178d0b510174b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c5d6c617b0b8f7cd72d00e7ec278b6f899adccc5cbc70291d178d0b510174b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00c5d6c617b0b8f7cd72d00e7ec278b6f899adccc5cbc70291d178d0b510174b"
    sha256 cellar: :any_skip_relocation, ventura:        "1aff641f58b0458e4f60899cf60979847d819b4450d06ca469209299fe499dfc"
    sha256 cellar: :any_skip_relocation, monterey:       "1aff641f58b0458e4f60899cf60979847d819b4450d06ca469209299fe499dfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aff641f58b0458e4f60899cf60979847d819b4450d06ca469209299fe499dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "455a59035e35133425ab3f5c324e49448642db61726b87d6a2e0e74ac7462b86"
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
