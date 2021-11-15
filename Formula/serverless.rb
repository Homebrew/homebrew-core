require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.66.1.tar.gz"
  sha256 "d6e6eec051e9834be3bb135fdf7db7c4d849fccc545774bb54a7dfec993250bb"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "790d10ca70ec1769302136d8f21dfe1e172ae0acf6b573d6fa42617bc84c1e0b"
    sha256                               arm64_big_sur:  "63597accdce5e0e54d2d25205f0f1e58c135578ec63d0c68504e8a867e9bb068"
    sha256                               monterey:       "a9a0723e6c6f5409d7a4ae37fd314048ee679a8e5921fc0dca5ba75ee73bf43d"
    sha256                               big_sur:        "08427f694ee855fa1dee70d4747c23f71c622416b9707d120546df2cf8a1f281"
    sha256                               catalina:       "93f89d4b473420f1aade3416392ecaa995032f87e3c03697b2953a094f0d0af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "363d011197b24361e12fbc4712e80141307dfd165a8bfab1350035f8865a2923"
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
