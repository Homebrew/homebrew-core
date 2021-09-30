require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.60.1.tar.gz"
  sha256 "fb6d479c011130c173a46882b4341801f9b7440dfd0ddf28b7b4e1cd52c0dab8"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "58091bcca76ddcd7d51a566197f3094bcdd16fca1979e793aa80639cb8bce5f3"
    sha256                               big_sur:       "106eb6b2cf3eb31a9f59e3ca216c9b138e4c14c6408a6b95d8384ed406caa9b3"
    sha256                               catalina:      "c19e90ac7ad5859bd2ad0bb01b4dff8adca145366b06ba470012b1f183db7d6e"
    sha256                               mojave:        "b01e64932191eb180c24f1d6b8357fec532e27e18c45b30082b7eda27eb2a6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b2ef12f092f6e8da5e30fb35663130ddd52a9a28499c094e56552dac742b78"
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
