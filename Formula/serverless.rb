require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.61.0.tar.gz"
  sha256 "d902fdcaa531cb94dd2e520c6b3a17750d650c6c54e409ad118a911df581c5b5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "97bcc4c8785f5fe799a6990483902aa08f52d6c5b96a8d1fdc1b9719cb0bdfc1"
    sha256                               big_sur:       "78b57a0e198fe1d3829e3c1aca0a507946e5ddda63980b0abb916490325d07a0"
    sha256                               catalina:      "80749913b468755051bdb8a5e872d8a6e895f67f838fadb37d5dfb29b406a0f5"
    sha256                               mojave:        "b0980110b057c21cd1fe0a64e048f55d75ef5b456c32d474a02e8f42df54853a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6281b13db13d75684612a25603a2f53be5926c805a8badb58c40ebd6c9147134"
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
