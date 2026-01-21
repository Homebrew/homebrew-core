class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b34b86506ec485c0484cbbe9dcfe85ad038197d3105fb675dc77e0e96b695d33"
    sha256 cellar: :any,                 arm64_sequoia: "df8fa85d5512e450ccc2926781aec5008481653cfecdaddac231f8c86bd7b42f"
    sha256 cellar: :any,                 arm64_sonoma:  "c57e32cbbce35e350cb366266e1772720f1abb2ba53c555b3d6d46c0f8cc8a53"
    sha256 cellar: :any,                 sonoma:        "4b2bcddb3709a988d2c1d4390801c45bc15e7e186e53b4ae18e5928cd0c4c02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e2043889ce46cf7176e1ad1da7eac5919ff7d3c17fe8d9fe514520d439f22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ced6196710aeedae773b3edcbb4dd104e3ca6c50de51a29586b5365863dc70c"
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
