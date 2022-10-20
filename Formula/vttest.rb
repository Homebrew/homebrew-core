class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20220827.tgz", using: :homebrew_curl
  sha256 "5726aae58137773ce6ce01fe6a86fc0f83c47763e30488bff35b9bc4fc946ce2"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "905038e27c10001f38e125fbb71ed34bc4cd5578a16e6e3976a135ba6edd5aa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fe35ac34ee9da6853f2d23252737d6e0d4bdbea42339568cb5e487a131dde60"
    sha256 cellar: :any_skip_relocation, monterey:       "98566281a72b1cdaac11e1b65c9a4becb01a1ed755344e4491608495f2839fdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "60edbb077a683fc7bc2815fad14352cc4b84f052d04f880225dcc941da6066a8"
    sha256 cellar: :any_skip_relocation, catalina:       "0ea68343e0652a287bfb43cc3354814ed890b3f219defc6f66d4a72b70effb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb08c3370eb7c6d16bba6ef1142a54c275a3c84e5aece356b8d022740d526b8d"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
