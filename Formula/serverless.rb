require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.1.0.tar.gz"
  sha256 "ef3bc2dde3413d7dab6f763c476620cb6935b622f8ca51ac5c2c59bad7948c5a"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec6f7f9281ed65700fdc0c129dd7da9d098321370846a8220d95755c56e8164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ec6f7f9281ed65700fdc0c129dd7da9d098321370846a8220d95755c56e8164"
    sha256 cellar: :any_skip_relocation, monterey:       "fed5443091242cd91ce3efc974ca3a87226aec8c089432ee04b425de26d2be90"
    sha256 cellar: :any_skip_relocation, big_sur:        "fed5443091242cd91ce3efc974ca3a87226aec8c089432ee04b425de26d2be90"
    sha256 cellar: :any_skip_relocation, catalina:       "fed5443091242cd91ce3efc974ca3a87226aec8c089432ee04b425de26d2be90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83799e2ebf595bd76e2aba4b3e3c13d5620c53ed83ace1246818bccc81f99854"
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
