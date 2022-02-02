require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.1.0.tar.gz"
  sha256 "ef3bc2dde3413d7dab6f763c476620cb6935b622f8ca51ac5c2c59bad7948c5a"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f5045452a00b257ed86c539dc793ac5ae9eba317d97224039855daf65a25250"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f5045452a00b257ed86c539dc793ac5ae9eba317d97224039855daf65a25250"
    sha256 cellar: :any_skip_relocation, monterey:       "d0c51b6ad21a258cd03a5f419ea1b5d7c44291052395e1039c67169db30b8483"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0c51b6ad21a258cd03a5f419ea1b5d7c44291052395e1039c67169db30b8483"
    sha256 cellar: :any_skip_relocation, catalina:       "d0c51b6ad21a258cd03a5f419ea1b5d7c44291052395e1039c67169db30b8483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab68b3cf7688c544317a7c21eee0cdb4b144eb0265a59fe2b7a11a135c81562"
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
