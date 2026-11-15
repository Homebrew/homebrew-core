class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.5.tar.gz"
  sha256 "84221a3abd5b91228f15f8e6065c335a336237b5738197b75bf419eea561a194"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08e15f04cd58bedfc69eb9f87fd528c77fd32799f7084e6cd78cdda06c888bd5"
    sha256 cellar: :any, arm64_tahoe:       "d77899c4baeac118aecdeea00047733d1420f8a1b86d509a5bb8cd6591f041ce"
    sha256 cellar: :any, arm64_sequoia:     "627b03499f9e0b076c16e25ec65c181ccfbf66aec7c8d065499c87c1e44dfd20"
    sha256 cellar: :any, arm64_linux:       "5a4289fd843c22c9d926f3059fc05f80fc008564a88eed4078f555cae01b7f8e"
    sha256 cellar: :any, x86_64_linux:      "ed9f4b418cd2e06796c2b24ba228c0900d38477da52baa44ef69865fc1b8e2c5"
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
