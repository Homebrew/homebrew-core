class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.3.0.tar.gz"
  sha256 "097aa2628cfbba2f8c2d412c57f7179c96082ab034fc6b2a2e905a0d344269e6"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2db665495e6e9e63509568597e743b36396b21cc7fefeffec7d1d072472fd1a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee395a1f1a6730ded82e4f64220678623762843b18bc805cdf237befe47bb44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e138df107b97d3b7ae13f15a0e619678ec524137bc7920aa1645145a30d8671b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4dc17a8cf542441964dcbd44553434630ab2a9dd2f3ce0c7d575ad35a2f83d1"
    sha256                               arm64_linux:   "160bd4a8ab8be3f425995ca39b341e4fe4d6ef57502bc26594c570c516eb9b3c"
    sha256                               x86_64_linux:  "c7aa992a3b853f63df789798f86737f4cd71cbba40dbbcc167d8ed62495607f0"
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
