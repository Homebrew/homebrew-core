class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.3.tar.gz"
  sha256 "3779a52e2f7d87d9616ec467344930b27d84ae1e8c57799b77f305bddf6ee297"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27afb4e8b4090f28a583bbf412e5aa66dd8061c84f0e22be15ca6395fb699af7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff4932710f2a7b201ff9c6cb43493f37dca6cd04574491d205e2f96fffbd2fe"
    sha256 cellar: :any_skip_relocation, ventura:        "29d81854d22e0f8ce8aba0086116e13d5c382ff9d263c7b9603f3f23d4fedef4"
    sha256 cellar: :any_skip_relocation, monterey:       "23a3b64d05a689bbeada45f2db507059b12baa261860de81acad9c2e67f86308"
  end

  depends_on :macos # Linux support is still a WIP: https://github.com/krzysztofzablocki/Sourcery/issues/306
  depends_on xcode: "13.3"

  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
