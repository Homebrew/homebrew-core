class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.2.tar.gz"
  sha256 "5a331606efbbd96336d99de2ddee67b111d5bbef678a30ac0bece3cf5b55afc3"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bafccb509c0586fd8725582aec7c7da7fe88055c7a8608d4ca0f5803a37988fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3d3c5407c9de6d7eb9d6dfdffa4fb01350c31d6d335bc26ff94eea7ed7e66c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9d6ed066d64296432ac9a1bc91aef8606c5d966c56f535fff011ae39fbea9746"
    sha256 cellar: :any_skip_relocation, monterey:       "039e1516d4cbdcb7107ac7a1777f9cb11891ef36a4b5f12ae6dd57b6157b6b3e"
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
