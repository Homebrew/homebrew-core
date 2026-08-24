class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.5.tar.gz"
  sha256 "84221a3abd5b91228f15f8e6065c335a336237b5738197b75bf419eea561a194"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77c03b228096892b70699b1eaf11ef1ce85d5803667331b29df0eb6f57d2421a"
    sha256 cellar: :any, arm64_sequoia: "b3f5eab7475ed4a0aecec1197c0843c7e9c83ee77f7e7d6adc19c2c538d047e4"
    sha256 cellar: :any, arm64_sonoma:  "82219b7fee13ddda4b299b30d64b3db2e9d0a67f9aec84c6ba6364b7f8cb9f33"
    sha256 cellar: :any, sonoma:        "284d78f65dabe067d5aae734fa3eb27a2e0c527e07ef4c972650e1b8b36c3541"
    sha256 cellar: :any, arm64_linux:   "edcf4ca1d66dfff2a979a9aa1019cead51fc86eba1327659fb80a374543910c2"
    sha256 cellar: :any, x86_64_linux:  "182cacc7e7f132b7df8b7b894068b2d215f391a255de9fdbb5266c313b4c4ea7"
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "ntfs-3g"
  end

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
