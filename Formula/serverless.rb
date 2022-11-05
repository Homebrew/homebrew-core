require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.24.1.tar.gz"
  sha256 "a54d7bb1b3ee26d14acf7321ac99f6f8c75fb13d45f3a56e384060103e8dbced"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602f622b6150096ef2a2b542f73ec633dfe415bf0ad8f47f8033d421f9304142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602f622b6150096ef2a2b542f73ec633dfe415bf0ad8f47f8033d421f9304142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602f622b6150096ef2a2b542f73ec633dfe415bf0ad8f47f8033d421f9304142"
    sha256 cellar: :any_skip_relocation, monterey:       "d7c8fcd22ff15e82db097e3e3b0fe82f4a1a3bcf654f21f44b1cfcb4e13ae91b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c8fcd22ff15e82db097e3e3b0fe82f4a1a3bcf654f21f44b1cfcb4e13ae91b"
    sha256 cellar: :any_skip_relocation, catalina:       "d7c8fcd22ff15e82db097e3e3b0fe82f4a1a3bcf654f21f44b1cfcb4e13ae91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d85e7d445786455be368683c91395bfa2559a68765a7c61e10b43170d01b52"
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
