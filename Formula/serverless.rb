require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.5.tar.gz"
  sha256 "9a8e7265b9816dce115a51ff5ae81dc8326d08db158b0d63b8aaf48f257842ca"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4c72e47da08e09876de81761113fb5cd311b669103d47d1d2efbaa5e04939a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4c72e47da08e09876de81761113fb5cd311b669103d47d1d2efbaa5e04939a8"
    sha256 cellar: :any_skip_relocation, monterey:       "51dc7fbac8a78453c1eefef3ba4c44ab2009f3d5145b76f5a5d6877a0b68a4c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "51dc7fbac8a78453c1eefef3ba4c44ab2009f3d5145b76f5a5d6877a0b68a4c6"
    sha256 cellar: :any_skip_relocation, catalina:       "51dc7fbac8a78453c1eefef3ba4c44ab2009f3d5145b76f5a5d6877a0b68a4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb738f461385af4720fd0a1f68bd6a5682d31c709283c4bbd44a55497050585c"
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
