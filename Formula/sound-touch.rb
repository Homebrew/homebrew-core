class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.3.2.tar.gz"
  sha256 "ed714f84a3e748de87b24f385ec69d3bdc51ca47b7f4710d2048b84b2761e7ff"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b8ab96643afdd0e29cb1c3ca87081de1e24a9fa71cf523f54d59700cfd89568"
    sha256 cellar: :any,                 arm64_monterey: "33ab05d5f4717eae082846a06976e7b01e9f29ce9a9b8281211d05ba63ee0d8f"
    sha256 cellar: :any,                 arm64_big_sur:  "c0470a1734cd05a4d9a944d35395af68dbcea9887292f2c27898b961537ab9e8"
    sha256 cellar: :any,                 ventura:        "81f327c5f8c915b65b7f301c25b75eeaddea4b902db42244082fbeef6c3371df"
    sha256 cellar: :any,                 monterey:       "bc814a3a96c7410dc2a07fb3abed06539fa8d124a7e2c5bb0d66ab8db14decce"
    sha256 cellar: :any,                 big_sur:        "774514a15a2e3426d4aec5c4c6e423ac6fa86589967fcd224103aca3ffd30c33"
    sha256 cellar: :any,                 catalina:       "af6a0cc123d0d5aa72770a890c3d5bebe60109670e99098d1950af5dd4591c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f734328dd552d6aaa65193e5c33a2e46fca6189780325fa77dd7d0b4c888f902"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "SoundStretch v#{version} -", shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
