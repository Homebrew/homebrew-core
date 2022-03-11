require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.4.tar.gz"
  sha256 "8445ae6c3207f845ba1dfe42973567cee7d5083a9d41965f5d511f782a40c899"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "399aa89519b87e5bb4c5cade56e294ebdc9c16536498667a3aeeb71b66079fcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "399aa89519b87e5bb4c5cade56e294ebdc9c16536498667a3aeeb71b66079fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "113c66174bf05f75255662a330e5d3a9931e5eb61dbdc68908c3d99baff400b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "113c66174bf05f75255662a330e5d3a9931e5eb61dbdc68908c3d99baff400b4"
    sha256 cellar: :any_skip_relocation, catalina:       "113c66174bf05f75255662a330e5d3a9931e5eb61dbdc68908c3d99baff400b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965cda6e8d3b98fe93097d2b16341c3667543653ac6f5705e17fb87dbafb2a92"
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
