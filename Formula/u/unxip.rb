class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip/archive/refs/tags/v3.1.tar.gz"
  sha256 "d76cabf3c0c057d87fd910ab0de5d9a1108b037f7e7406802f40885d80d49295"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf884e88603357d56ed83f95f8d1bc6f366e3542578d823beb6414c97240d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b25d509ece5113ddc99bb39e0ce031b578be3a6d146ecce3105e208da6f214c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f685faaad5e16412bce583d9420617136a7b3b04d2b399b6c25492afcddd54"
    sha256                               arm64_linux:   "2307c9e9f92bd26c481d2754d2026470a8c9197af2ac0fba2b2da1081366a713"
    sha256                               x86_64_linux:  "e8ce3607ab1d6aeb51833fc2862c38e28068d172d00b865a89cd2d305ebf69a3"
  end

  depends_on macos: :sonoma

  uses_from_macos "swift", since: :sonoma

  on_sonoma :or_older do
    depends_on xcode: ["16.0", :build]
  end

  # Uses Compression framework on macOS
  on_linux do
    depends_on "xz"
    depends_on "zlib"
  end

  def install
    args = %w[--disable-sandbox --configuration release]
    args += %W[-Xcc -I#{HOMEBREW_PREFIX}/include -Xlinker -L#{HOMEBREW_PREFIX}/lib] if OS.linux?

    system "swift", "build", *args
    bin.install ".build/release/unxip"
  end

  test do
    assert_equal "unxip #{version}", shell_output("#{bin}/unxip --version").strip
    # On Linux we don't have `xar` or XAR support in `libarchive`
    return if OS.linux?

    # Create a sample xar archive just to satisfy a .xip header, then test
    # the failure case of expanding to a non-existent directory
    touch "foo.txt"
    system "xar", "-c", "-f", "foo.xip", "foo.txt"
    assert_match %r{^Failed to access output directory at /not/a/real/dir.*$},
      shell_output("2>&1 #{bin}/unxip foo.xip /not/a/real/dir", 1)
  end
end
