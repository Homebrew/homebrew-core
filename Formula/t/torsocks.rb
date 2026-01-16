class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitlab.torproject.org/tpo/core/torsocks"
  url "https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v2.5.0/torsocks-v2.5.0.tar.bz2"
  sha256 "31a917328b221e955230b7663abfbc50d3a9b445a68cb0313c11cf884f8cb41f"
  license "GPL-2.0-only"
  head "https://gitlab.torproject.org/tpo/core/torsocks.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "176eff92c63f1ea09319b33df72fb67b6a1f57f1da4df3cdfcf8a0c60e9b0e22"
    sha256 arm64_sequoia: "9f967a566d267075d63cb069a6d77973bfc4cb5e1244c2ca57171a04352f0b26"
    sha256 arm64_sonoma:  "b25792853457dbbc903f6aac9d252de7889ba0006c5a0cb904a9428cee03c066"
    sha256 arm64_ventura: "4593fd902084328734cda9b1bfccd26242211d6beae0c510100630fbf31b07c0"
    sha256 sonoma:        "df428080ebd167aecf3abb603b6207ad469c9c52c55677a4e8deb0635ef1fac1"
    sha256 ventura:       "383a9b0bcdc089b45a2a13badbf11aebcf37674b749f086636d432bca79b6f2c"
    sha256 arm64_linux:   "3a273bb1e5923f05e4caa4d9a269c97020844c935a36845224acf4bf7799e129"
    sha256 x86_64_linux:  "4b4330e179d1c4a866f8be595ed65c1b443f5cc40e21bb30d0fb6be030c6e6a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://gitlab.torproject.org/legacy/trac/-/issues/28538
  patch do
    url "https://gitlab.torproject.org/legacy/trac/uploads/9efc1c0c47b3950aa91e886b01f7e87d/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"torsocks", "--help"
  end
end
