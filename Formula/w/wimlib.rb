class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.4.tar.gz"
  sha256 "3633db2b6c8b255eb86d3bf3df3059796bd1f08e50b8c9728c7eb66662e51300"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "dc46d8e6c9dd8a394459c8735c03e02dd0ff8e4f887e3849e87793553492a0c6"
    sha256 cellar: :any,                 arm64_sonoma:   "8cbbeec3b621170d4577412d4c0a240e27a07a9471ffa6f28186ccb26c601592"
    sha256 cellar: :any,                 arm64_ventura:  "295512a48ab0166b7e217a83b106bc7e7e01cbf3a6f343eaedfa97a899eb4d92"
    sha256 cellar: :any,                 arm64_monterey: "9f8f4f22847e831915fccdeedfc885108dc2d6f6d80e276d4932484015bba54a"
    sha256 cellar: :any,                 sonoma:         "9822e536911e162bb367cfd73ac94ff7ef30a9b0d604400d7702fb4bee072f0e"
    sha256 cellar: :any,                 ventura:        "77a2f91a0c2ca081a2f50ff5f4b9f3ea4f9e79a3c19705f71309c8c60d08e5d8"
    sha256 cellar: :any,                 monterey:       "0f92288eb4efd7316e705cf1a6d1729f8b6eee81beb7ea57daf15f968c0c53ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4710658e4473cd5744958616b25eb4c19bf61ffec09c42cd748ef4d0ce26c3b0"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    # fuse requires librt, unavailable on OSX
    args = %w[
      --disable-silent-rules
      --without-fuse
      --without-ntfs-3g
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    # make a directory containing a dummy 1M file
    mkdir("foo")
    size = if OS.mac?
      "1m"
    else
      "1M"
    end
    system "dd", "if=/dev/random", "of=foo/bar", "bs=#{size}", "count=1"
    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system bin/"wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system bin/"wiminfo", "bar.wim"
  end
end
