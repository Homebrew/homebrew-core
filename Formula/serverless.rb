require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.28.1.tar.gz"
  sha256 "fa39b1ddb5cae83bb095b9d7054f45a320d8c0799c14777272d5cd19199d6ad2"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e857ae13a004ebfd143754384b8148d715bab2cce4f48c216b35ff1c9c0e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e857ae13a004ebfd143754384b8148d715bab2cce4f48c216b35ff1c9c0e60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56e857ae13a004ebfd143754384b8148d715bab2cce4f48c216b35ff1c9c0e60"
    sha256 cellar: :any_skip_relocation, ventura:        "971878f42b5d51a25c4856db31ae2eaf0dd0d7d5335ddac8bbea9f192795bd73"
    sha256 cellar: :any_skip_relocation, monterey:       "971878f42b5d51a25c4856db31ae2eaf0dd0d7d5335ddac8bbea9f192795bd73"
    sha256 cellar: :any_skip_relocation, big_sur:        "971878f42b5d51a25c4856db31ae2eaf0dd0d7d5335ddac8bbea9f192795bd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfbda14dbb82c44ff6a7e0bea1a2b8351c7bba29a7296b9d8ba243bf2899f3db"
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

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
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
