require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.64.1.tar.gz"
  sha256 "f2a242b575d12a61e9a8f4969f99d295bdfd6d56f7c1dd18128827fa1e4bd318"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "86acb28061b84a873dab209970a58e4c539cb581eb3a0354dad9bdf77720c106"
    sha256                               arm64_big_sur:  "b52373941a999233c8c9853a51f83c85c3854d9cbfae67c12ebbd90dc4b93aba"
    sha256                               monterey:       "18a4e8c673337e2db90548f1242706bcf78fd8cf9bfc066f5993dc9629cb6b36"
    sha256                               big_sur:        "f14d7c11e437f139b833f6147cb79a5378e02f794c8e2c42a7677d4295bbae61"
    sha256                               catalina:       "98b398f6f9156ee53c87c0ce7ec10b5ca3fe244c0c107827e3b5c56d7c3efa15"
    sha256                               mojave:         "8997cd1a49b7e22824d896fc299f2ef14869eaad0663d6d4afe80c4320142c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5ae93a1a8e83802e06cb0502eeed2743e25789a94e46e410a992473968dc05"
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
