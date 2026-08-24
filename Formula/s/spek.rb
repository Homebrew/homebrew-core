class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8373626cb49d786277b4347c1684431a6fe4732bdcf08b06c14860b4be8ccf1"
    sha256 cellar: :any, arm64_sequoia: "b0a68889610aaf39000f9435f7f99d0e093969babb0695fdad39689a75bd2dac"
    sha256 cellar: :any, arm64_sonoma:  "96d28527640336b7d2ca39687b9b66d56807565f33808c9d3f6eea0085ca9e33"
    sha256 cellar: :any, sonoma:        "6b27bbda4bebbb1b271b5a4541388c0ff7342af863316f07f7f909cb8f736462"
    sha256 cellar: :any, arm64_linux:   "894e5ac513494420ba3a96fdfb187365589d20cb9becb13f4628aeef8cea2cf8"
    sha256 cellar: :any, x86_64_linux:  "703fb5b95180d12fce814c61e079c903eddfb5bdc92970d12d06fc0fc86ce6f6"
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
