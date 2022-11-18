require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.24.1.tar.gz"
  sha256 "a54d7bb1b3ee26d14acf7321ac99f6f8c75fb13d45f3a56e384060103e8dbced"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76a8c81bb3f5e1e795c2fcdc2fc8618552a6439f998f8451079605ec034d4a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76a8c81bb3f5e1e795c2fcdc2fc8618552a6439f998f8451079605ec034d4a12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76a8c81bb3f5e1e795c2fcdc2fc8618552a6439f998f8451079605ec034d4a12"
    sha256 cellar: :any_skip_relocation, ventura:        "10ddf91f9d306d37f07be4ace87f4e34bc3d309c8e39b547f7db35b9caf0ab23"
    sha256 cellar: :any_skip_relocation, monterey:       "91e2fb0fd05229b18a4e4eb0c1969162390c64c16d96da8582bce14483acef6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "91e2fb0fd05229b18a4e4eb0c1969162390c64c16d96da8582bce14483acef6a"
    sha256 cellar: :any_skip_relocation, catalina:       "91e2fb0fd05229b18a4e4eb0c1969162390c64c16d96da8582bce14483acef6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "274b59ccaaf1efc1a1b7d9521c1a46f67dafef37e3eed0932d021ef9adf3f5df"
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
