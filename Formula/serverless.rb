require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.66.0.tar.gz"
  sha256 "b2e720ab03d0f32767e4a2e4934e3a9bec941fb384258a004cddb051f15be652"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "346f2d48d09d00d316aff1481f1cdf3375e22f8c8890b6c4078d83a5c02ee84e"
    sha256                               arm64_big_sur:  "e85853eb666472772e582038f0b3bb99c4710affe9441f3121ce181277f595b1"
    sha256                               monterey:       "33054567c5333aec2d8717aea0f351c5b720c37ea7051719089ba2fe4715396c"
    sha256                               big_sur:        "7c3ad075d605f29657e65513cdaaea9b78b43734a49ff458272754051b276547"
    sha256                               catalina:       "80550db2a56bb299e5ab85508c9ca3ea1099962f6d9882bdc46fd3007f8d5b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495d3b68dbf7c2ef1c26beefac7a3b2c7ded82a4c9e579e35cf5459b652ed34d"
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
