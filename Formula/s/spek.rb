class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7857d941aa80e7ecc1cb4195962e52a883492fa55856e69b12a53ae1630eac4a"
    sha256 cellar: :any, arm64_sequoia: "61b6dd56dc3d66546e71f1a6d534fdea66866a98280a55469eab498ad6282adb"
    sha256 cellar: :any, arm64_sonoma:  "c5e8729fbb89428fa3faf7af17abb3f4499cf170d845956665133d318fb13dcb"
    sha256 cellar: :any, sonoma:        "2d8d61fa579a5c965af5c69b7cf03d63a0fbb388aa3b66bf05383673b82b17e2"
    sha256 cellar: :any, arm64_linux:   "34bb8c8ed976ce58aa073445ba5d9b03166fbc04907a4de047c072cb71acdb29"
    sha256 cellar: :any, x86_64_linux:  "ad4e0d4b48cf6b0a5d56c7d537c2c6c09fc35e9dd3453be2b366ffbe8765b116"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  on_linux do
    depends_on "xorg-server" => :test
  end

  # Apply commit from open PR for FFmpeg 8 support similar to FreeBSD and NixOS.
  patch do
    url "https://github.com/alexkay/spek/commit/df8402575f1550d79c751051e9006fd3b7fa0fe0.patch?full_index=1"
    sha256 "1ec33c6a2c0dd6d445368e233a3c0855c4607af902e2ca5dd48b2472df7df797"
    type :unofficial
    resolves "https://github.com/alexkay/spek/pull/338"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/spek --version"

    pid = nil
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pid = spawn(Formula["xorg-server"].bin/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end

    assert_match "Spek version #{version}", shell_output(cmd)
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
