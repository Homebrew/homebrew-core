require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.72.1.tar.gz"
  sha256 "98ac8c95d4c13ee2416de1f02fa846b12ef3f2781352f52385408d23190fcd9b"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "8620c4e93b0ad66f90b696c7174eea1bcb4d455b277d7ace78e7328b102dc81f"
    sha256                               arm64_big_sur:  "66a1f74d27a9a781828f9a4edfaa36c8deee167260d4ac87fcf0387c1b9e776e"
    sha256                               monterey:       "70fcca4a1dda5a1579a6549d66f971e5f059f9478208a1dc7f113b77a6a46855"
    sha256                               big_sur:        "2565a1b157a9fad7e2d4dbfdf17fc1b0e334eb21e20bd0e677bdaa6571271426"
    sha256                               catalina:       "fcad70f917e120f72cde597be8c395ac1c5dfb4880dbd12c9d3fe0339a024e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39757dd4cd97cee107a526e9641a0a5684273aeaf88c21e9724d7d086e6cbca"
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
