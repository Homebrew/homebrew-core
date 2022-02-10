require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.2.0.tar.gz"
  sha256 "52dacab2af64937a04d4709d2d4ba4ce797c7b8f1c4e6bde5e2047baca24f03d"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5278b3919f652413edda6535f256d0f88612ff505e8e12d7b40b567ff0a35809"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5278b3919f652413edda6535f256d0f88612ff505e8e12d7b40b567ff0a35809"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fa40b08263e2c94f99895f399f66174a7f8c20488741d2162ba1c1e5f537ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f757c4f3f67569643bbd45abfa9d29b6582f8aa8fe1f763a9e1069a211ea2a0"
    sha256 cellar: :any_skip_relocation, catalina:       "e6fa40b08263e2c94f99895f399f66174a7f8c20488741d2162ba1c1e5f537ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682f7038551be77645cd392f6096a41aced3b4f5aaab35f84f748de301e7319a"
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
