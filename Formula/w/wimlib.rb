class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.5.tar.gz"
  sha256 "84221a3abd5b91228f15f8e6065c335a336237b5738197b75bf419eea561a194"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "951bf9ddae69ebd6442a44d1f1e39679a2c5655c4fcd32510eb6643db62dc3ea"
    sha256 cellar: :any,                 arm64_sequoia: "f68999bc5e316bdbe49da07b9e19d666d4af22cfb142f5cefa17a6164230f5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "e1ea0499d1740f2f5068cc4f7a298020559924e9be21c76d30a5dbeb8d93f4ae"
    sha256 cellar: :any,                 sonoma:        "705581a3fc296d50a26abc3fd4a998e4e09e146366e636c9486ead31855d1372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6c19ffd2caac844bbee911908b820cd7345455b089e0aa20438ed4aee1f0319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be666177d8950f104c6bd2e72d7c19a89477e24e5c1873b66539bce538a0415d"
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
