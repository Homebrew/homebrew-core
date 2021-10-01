require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.60.3.tar.gz"
  sha256 "880352b9868fee2b886111aba9d70d5159eebf1708700293f8e27101b356fa4f"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "cf07a717f1329fa24cd21994eb257771ff641df22c3414497c4f3a5184c08757"
    sha256                               big_sur:       "2f6c5064b393bb7849a2ca6d0af8dbed0d7b06f6709673b7a17f2c6721a087b6"
    sha256                               catalina:      "c77c8ad91d0ea4ae85f835ba1b03b1fa4280e96e183c47c4b35d542f1dbed9a6"
    sha256                               mojave:        "4f19ce9a45eef526435f4d7088afb8b8e50a0fa44df84e5f591ecb127750a41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf251481e3c74318b7ee85d492eafd9b366f968e673dac50545c07d6e585d34a"
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
