require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.61.0.tar.gz"
  sha256 "d902fdcaa531cb94dd2e520c6b3a17750d650c6c54e409ad118a911df581c5b5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_big_sur: "6ed9cd33adce1b57b8af14335fcdf3d63c62c92c400b3b6e20edec35c7cefeda"
    sha256                               big_sur:       "ea3fee3c42145179509280e6fbb1ccd60a43a068c1ca57ac32b2ec63678fa1db"
    sha256                               catalina:      "e1ee000be79c16f853e1ec5aa06603a944a0bd9c984aa4b45c3e6dc5a3f407b9"
    sha256                               mojave:        "32fd4e5d450edb063dce21c1be5afbb481821ccaf4ad0bb7fd20a1ac3e09ecbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78f4054009d2ff55fd1ea855f29d53d925bf62fd69bda11d2b038e3fed655af"
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
