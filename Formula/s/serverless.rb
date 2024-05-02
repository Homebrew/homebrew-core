require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/refs/tags/v3.38.0.tar.gz"
  sha256 "8d4cc3ab2005c7fabf101543f0926d0daac5ba60ee3429864f523144f7affb12"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a36747821d2c1650b5196c2ed25a0c1cb3622246556b55c32c09b525a8f6e2fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a36747821d2c1650b5196c2ed25a0c1cb3622246556b55c32c09b525a8f6e2fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36747821d2c1650b5196c2ed25a0c1cb3622246556b55c32c09b525a8f6e2fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "29ebd0578d088b62943e728501b6bf4a91d962416aac03782ce1d6517a1ed221"
    sha256 cellar: :any_skip_relocation, ventura:        "29ebd0578d088b62943e728501b6bf4a91d962416aac03782ce1d6517a1ed221"
    sha256 cellar: :any_skip_relocation, monterey:       "29ebd0578d088b62943e728501b6bf4a91d962416aac03782ce1d6517a1ed221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8d8d6518fee287db03291589566adec65083981167ce3d80a7a4ace069e693"
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
