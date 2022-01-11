require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.71.0.tar.gz"
  sha256 "91486d996029f3e5f7871521cab23b3f33a1685ac8ceaf11cfddae6939a14475"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "6f901090c8772b7fc1ff331d79a22148ee7335212c38b630e58582ab7a1b0f58"
    sha256                               arm64_big_sur:  "ee9ef34dda9246fbf890838838eee1af550fd016dddab2554ee4aa92ae8cbd14"
    sha256                               monterey:       "3af9889c263cf1040d81f1240d24f416db1c9881508696a3e8fb2e85b7769c42"
    sha256                               big_sur:        "0025dc1e581333079e668c1b79f9b17872c91add7e4c1cbf16a71a86fd4b638b"
    sha256                               catalina:       "61f9642eecc6cb026a5d58bd73501c55e1f675c4086042f98ac37d8f7547b217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15dbee838aaa26e801506ff66201e0cba8b14ba2d26253a0a8ba263678e64e61"
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
