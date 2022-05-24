require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.18.1.tar.gz"
  sha256 "7867a49cf63b686afcf17fa797e0a34b0bc0481fedcdc8e1353459e0e37c0ecd"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282a604a23039c0e5984df13a55039e5d7a2f05fdedb92ceff20c43e9bdfc66c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "282a604a23039c0e5984df13a55039e5d7a2f05fdedb92ceff20c43e9bdfc66c"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc04f383f8ea2f2081bfc247ead75d8de1fc254361d9b58319613f6778fc2c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dc04f383f8ea2f2081bfc247ead75d8de1fc254361d9b58319613f6778fc2c9"
    sha256 cellar: :any_skip_relocation, catalina:       "8dc04f383f8ea2f2081bfc247ead75d8de1fc254361d9b58319613f6778fc2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c67780b940a8fd3fbac46dbc3db95df78c36024b07a4895d2535d754a208a9c"
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
