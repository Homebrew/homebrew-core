require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.33.0.tar.gz"
  sha256 "f1901e04694d38c3cec1709ac2877b461e0dfbd13c9a0c184cde2cfeef99b839"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ace3337c547dacb6c82b605f162e7a3347093c8b09d490b38b8ff3a5a5773bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ace3337c547dacb6c82b605f162e7a3347093c8b09d490b38b8ff3a5a5773bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ace3337c547dacb6c82b605f162e7a3347093c8b09d490b38b8ff3a5a5773bb"
    sha256 cellar: :any_skip_relocation, ventura:        "d1fe0d6f654b13f5c2856dfeea9b79fcfda31e52ddc6ca2d83a94346a186d687"
    sha256 cellar: :any_skip_relocation, monterey:       "d1fe0d6f654b13f5c2856dfeea9b79fcfda31e52ddc6ca2d83a94346a186d687"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1fe0d6f654b13f5c2856dfeea9b79fcfda31e52ddc6ca2d83a94346a186d687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a9b81d9bd4bd1f22d1ad391d2774d63f962c39f8a5fb8fd2ae5b6ec1c29d02"
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
