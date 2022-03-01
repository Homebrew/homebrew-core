require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.5.1.tar.gz"
  sha256 "9d0474fa6fd74b7428167a764fd32cc85ea52c82dfd9f1b0166a41f4b15cabcc"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b190b882d93187f9d202b8d9fbc7ca23137c0173f699c03f2ecbd0ae120935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b190b882d93187f9d202b8d9fbc7ca23137c0173f699c03f2ecbd0ae120935"
    sha256 cellar: :any_skip_relocation, monterey:       "94eee21c5e0d8db566732b704398447fc6fd341b9965f20d0eaf75d83ac61462"
    sha256 cellar: :any_skip_relocation, big_sur:        "94eee21c5e0d8db566732b704398447fc6fd341b9965f20d0eaf75d83ac61462"
    sha256 cellar: :any_skip_relocation, catalina:       "94eee21c5e0d8db566732b704398447fc6fd341b9965f20d0eaf75d83ac61462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a82b97f2c074b482afd76c8a70eb267619b3e079be599aef2ce788b3094b28e"
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
