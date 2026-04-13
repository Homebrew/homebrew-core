class Unxip < Formula
  desc "Fast Xcode unarchiver"
  homepage "https://github.com/saagarjha/unxip"
  url "https://github.com/saagarjha/unxip/archive/refs/tags/v3.3.tar.gz"
  sha256 "490c27aeabad33a8c811ada09008d24835f0f701ad40092b450c4788cdf99198"
  license "LGPL-3.0-only"
  head "https://github.com/saagarjha/unxip.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b6c919fc617737fbffc245d013c8e7512c6d7db1c33df373b2afa79d82db96b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b878c072c1a77f52d4e7cf49875b9237d32227aa4fec26c39a88de74081b42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2707cf947f3c5a15b59a74fd8822efb1ac92d002df0164a70f53ef7c7e96871f"
    sha256 cellar: :any_skip_relocation, sonoma:        "21d28010c3c9aac3ce826ff7a0f3ecb87d258786848b0b879e982b850388b707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc43a268cc4b16019d4f8b2379117f91e34f3ebab4eb25d516fc94a290baeec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f980d6217df53dc0c7e7c976a4a8bca29e7c38028876ce17184917df790253f9"
  end

  depends_on macos: :sonoma

  uses_from_macos "swift" => :build

  on_sequoia :or_older do
    depends_on xcode: ["16.0", :build]
  end

  # Uses Compression framework on macOS
  on_linux do
    depends_on "libxml2"
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[--configuration release]
    if OS.mac?
      args << "--disable-sandbox"
    else
      args += %w[--static-swift-stdlib -Xswiftc -use-ld=ld]
      # Swift doesn't run our CC so manually pass in shim include paths to find correct headers
      ENV["HOMEBREW_ISYSTEM_PATHS"].to_s.split(":").each { |path| args += %W[-Xcc -isystem#{path}] }
      ENV["HOMEBREW_INCLUDE_PATHS"].to_s.split(":").each { |path| args += %W[-Xcc -I#{path}] }
    end
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
