class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/refs/tags/v3.39.0.tar.gz"
  sha256 "8f9f90af64b4ddf9df872b6a998ce943d82a479d0f138f804a0e84d4f24b74e3"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "v3"

  livecheck do
    url :stable
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "40a382f6cdcf4825bbb0118b438aed6df7c90eb2b7059cf6ffcddcb74a7d90a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e02bdf9c7eef601c900ef5a53ab322401177dde6d819bf5d45a680516e02eb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e02bdf9c7eef601c900ef5a53ab322401177dde6d819bf5d45a680516e02eb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e02bdf9c7eef601c900ef5a53ab322401177dde6d819bf5d45a680516e02eb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b66193d11a01a3796d856e79ec07d97729c2f589d0d9c478baaa9c7b31f881bc"
    sha256 cellar: :any_skip_relocation, ventura:        "b66193d11a01a3796d856e79ec07d97729c2f589d0d9c478baaa9c7b31f881bc"
    sha256 cellar: :any_skip_relocation, monterey:       "b66193d11a01a3796d856e79ec07d97729c2f589d0d9c478baaa9c7b31f881bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a06872b8191f9c75f9b346aa19a134db12ac6641683039ffe87eecebf8df9582"
  end

  # v3 will be maintained through 2024
  # Ref: https://www.serverless.com/framework/docs/guides/upgrading-v4#license-changes
  deprecate! date: "2024-12-31", because: "uses proprietary licensed software in v4"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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

    system bin/"serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx"
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
