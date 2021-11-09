require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.66.0.tar.gz"
  sha256 "b2e720ab03d0f32767e4a2e4934e3a9bec941fb384258a004cddb051f15be652"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "60e6b809c5943673224770bc59544b51affe99e17d4b927481228dcdd040b01e"
    sha256                               arm64_big_sur:  "e6fa6bd67ed51a5999c80f4f8c585e0fef7896b2f99f48a053dfcedf2bd498de"
    sha256                               monterey:       "0d31cf37067f69c08f531a75e7c5bbc327428b11a6493034a23ef3a7578547ab"
    sha256                               big_sur:        "d9ef3cfdacf18bb4f01434d3dd63873e13d105a676871c2c9ec34b16decb474e"
    sha256                               catalina:       "0a4cd6635b8bc87e2affd00c8b9db961450e8ec0b170cfe72b045a1065f76f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1072b8aed081e8eb00685d8631a772edff6d70792e8f84691c442858681901cf"
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
