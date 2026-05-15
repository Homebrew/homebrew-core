class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/refs/tags/1.1.7.tar.gz"
  sha256 "8d53fbcd1283cea93532d8b301f11353bd7634d865c8148df3bc3f65d0447a19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cf53f642dde97db220e7bff17a8d7660c230416fea7ab058af0aab8ff20ebfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b2c94574fbf1393924f73651ea3276ccc59168872c2e23cced5a2844a895a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c09fc8fbe98be3de2104a764b2a061ae395268fce3dbbe9720aa41fe601ef830"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c713370dc58cfbc20047ad65231048f4195297dd9f351d10551cb9f3e4381e7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ec011fe16385d889653c9e3eb7c6ed689107cb92c8c7d6482e3f3b72d7ec27"
    sha256 cellar: :any_skip_relocation, ventura:       "0cf043e6335d98a3024183b86305c5375b2b1311637f76a062883cf37d9f6309"
  end

  depends_on xcode: ["11.2", :build]
  depends_on :macos # needs macOS CommonCrypto

  uses_from_macos "swift"

  conflicts_with "service-weaver", because: "both install a `weaver` binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
  end
end
