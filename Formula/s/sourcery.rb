class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.7.tar.gz"
  sha256 "e543ba8c3f05d9c8ce6b9dc0460d2084893f345d4f5984aabe31a40849a5c0e0"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "492ed39e90b1fa57dfd06fe1232473e57d9b5b7f110453d04387db5a76f19192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cef0fe60955af53805a58f3da3d80e6b0849835a8892d7cd31e885ff98afc3f"
    sha256 cellar: :any,                 arm64_ventura: "7bad173e863423cf66b082d6f1f9e7f34a73fe121aabb3ca29a81be10ed7e707"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d82c40e46e20b5e60908144e8d58e440798c802a545a2b3d3fbd2db70b87b74"
    sha256 cellar: :any,                 ventura:       "e621c3cc046ef8c5336b796ad72c36ee2d608b518b5bc746f78d04170c46d2aa"
    sha256                               arm64_linux:   "5bafe848b77836b034a0c8f0c3c411267feac36e5ee758f184ce7c38197d446d"
    sha256                               x86_64_linux:  "f0818110b2abe047e9055f761a77c7321f69e5e6563187213461bea738fa46fd"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    # Build script is unfortunately not customisable.
    # We want static stdlib on Linux as the stdlib is not ABI stable there.
    inreplace "Rakefile", "--disable-sandbox", "--static-swift-stdlib" if OS.linux?

    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
