require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.3.0.tar.gz"
  sha256 "cdc5b2b5ef47294bc820e30a73e7e43f85c835a75f6ae93b41a24257cd78b583"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1566f2e57a4b95d47a57dd2aba0062d3a9bd69a8045580f8d3e182b4b5bfe348"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1566f2e57a4b95d47a57dd2aba0062d3a9bd69a8045580f8d3e182b4b5bfe348"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9d1a4864b666474bc461bf28c80a8970df04e5763977cbf312d56cfe5e9d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed9d1a4864b666474bc461bf28c80a8970df04e5763977cbf312d56cfe5e9d6a"
    sha256 cellar: :any_skip_relocation, catalina:       "ed9d1a4864b666474bc461bf28c80a8970df04e5763977cbf312d56cfe5e9d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d54e1626051e0c448b31b19a599b513771d73eb9a000bdf6966cdeacea2ff46"
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
