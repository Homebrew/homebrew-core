require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.10.1.tar.gz"
  sha256 "daf092fdeda99be738106cd93288941fa8beae78448b0509c6645fa2a62c7855"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38c67f7291760b3846aeef25eea6385436d0442f17ea0925626433be0ceb912"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38c67f7291760b3846aeef25eea6385436d0442f17ea0925626433be0ceb912"
    sha256 cellar: :any_skip_relocation, monterey:       "1332e89ee0b9f73f9144b39884756a0e9dc6132cb7121954fb6964c74c16d598"
    sha256 cellar: :any_skip_relocation, big_sur:        "1332e89ee0b9f73f9144b39884756a0e9dc6132cb7121954fb6964c74c16d598"
    sha256 cellar: :any_skip_relocation, catalina:       "1332e89ee0b9f73f9144b39884756a0e9dc6132cb7121954fb6964c74c16d598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c91ae61979b989ed6b84b6c3ed5190b4f5fae753a145afd949317a88870dea54"
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
