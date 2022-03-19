require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.7.9.tar.gz"
  sha256 "0e31e072f712a63d7e5131750fa84973122587680ff241ed1afc1be5a782c48e"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d0bec6414216a5607bb1d786b952d898a4353e7d25e63f10bef630e5bd8c818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0bec6414216a5607bb1d786b952d898a4353e7d25e63f10bef630e5bd8c818"
    sha256 cellar: :any_skip_relocation, monterey:       "53a88209a5ad57afec34fffdd49c9752955e94406a1170d04fe0faacbc7ee5b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "53a88209a5ad57afec34fffdd49c9752955e94406a1170d04fe0faacbc7ee5b5"
    sha256 cellar: :any_skip_relocation, catalina:       "53a88209a5ad57afec34fffdd49c9752955e94406a1170d04fe0faacbc7ee5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3344d3765316243211dd9100b5f3fc8b61eccf476df1da2e4bb2bd82af3196"
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
