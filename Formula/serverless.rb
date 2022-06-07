require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.19.0.tar.gz"
  sha256 "3cb4402135903864b93a7dea105873f7523febfb8b622352fa4bbcdd6fc67678"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9423455c659f84f38506d0a881f1aaf06a711bc339a668b063e04ed10ebb2c7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9423455c659f84f38506d0a881f1aaf06a711bc339a668b063e04ed10ebb2c7c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5094477385691f643ed937fcf01aa52e032cebaa0ed243f11a05157c2581f4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5094477385691f643ed937fcf01aa52e032cebaa0ed243f11a05157c2581f4a"
    sha256 cellar: :any_skip_relocation, catalina:       "a5094477385691f643ed937fcf01aa52e032cebaa0ed243f11a05157c2581f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4630256de52096e7266e1897dd7cb66fb76089d2822ad642d559dfdbe096bf0"
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
