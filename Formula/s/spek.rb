class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35bf9a140676a8e6205c91c540decde724994782b3159cfae796d354e976e20f"
    sha256 cellar: :any,                 arm64_sequoia: "ffc78727f112cb7bfabfa57acdf7ea1355a7df9047e989baec54a0afef6d5576"
    sha256 cellar: :any,                 arm64_sonoma:  "48c21438781605fb9f76fe35029e0beaee74eb9ed07bb99ff742f9fa9abc5dfe"
    sha256 cellar: :any,                 sonoma:        "b68f5b7d147ba25ff5e4026ab742c8e943f7b03df35cc79531ddced4fb01eeed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a810d0852931abf03233d899d3c3f96378dc103ed9383e9a1069de52cbdd1a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c2ca54ed0606804bca9e037600403fb578443640dcd447d6141cb6f5ece99c"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  on_linux do
    depends_on "xorg-server" => :test
  end

  # Apply commit from open PR for FFmpeg 8 support similar to FreeBSD and NixOS.
  # PR ref: https://github.com/alexkay/spek/pull/338
  patch do
    url "https://github.com/alexkay/spek/commit/df8402575f1550d79c751051e9006fd3b7fa0fe0.patch?full_index=1"
    sha256 "1ec33c6a2c0dd6d445368e233a3c0855c4607af902e2ca5dd48b2472df7df797"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/spek --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "Spek version #{version}", shell_output(cmd)
  end
end
