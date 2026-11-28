class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.5.tar.gz"
  sha256 "84221a3abd5b91228f15f8e6065c335a336237b5738197b75bf419eea561a194"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "910f873cbfda7116f8d58f3b3877d85de88ad268b596b334e1518e3d9a37f989"
    sha256 cellar: :any, arm64_golden_gate: "d1b8d566ea4fd0dd897bc7ed5e5cd322a6c38194c43360c817e5e70cdc2ba3c5"
    sha256 cellar: :any, arm64_tahoe:       "4f6e2f3db1ab0e023d4196bc45eb1d332a626087e3c795aab5fc26a75d374a60"
    sha256 cellar: :any, arm64_sequoia:     "9017b4bee50fd80b9b04b7ba3ad13cf2085c8f280de20b908d3becfcf2a9c069"
    sha256 cellar: :any, arm64_linux:       "379fdb7700e3270d993205c7c36fbb034261ab3e0eedd801d5f5aca9b181e0b0"
    sha256 cellar: :any, x86_64_linux:      "cc126ffba2bd3d6cacfb98fd9964d9febd8f1505480dddac38e45d988ec4bc83"
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "ntfs-3g"
  end

  deny_network_access!

  def install
    args = %w[--disable-silent-rules]
    args += %w[--without-fuse --without-ntfs-3g] if OS.mac?

    system "./configure", *args, *std_configure_args
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
    assert_path_exists testpath/"bar.wim"

    # get info on the image
    system bin/"wiminfo", "bar.wim"
  end
end
