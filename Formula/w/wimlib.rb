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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0e65ded347adda5fda6167017ee666f76dea3257916600281531ba9913fa14fe"
    sha256 cellar: :any,                 arm64_sequoia: "a5ea3961385c62f66efecd74eb8cb16533a12214b638b2dcc3bc552c3666a072"
    sha256 cellar: :any,                 arm64_sonoma:  "cd90cbc5afd8825d5693a3a15b6728392eadb8d17620fefec7418521b117a90d"
    sha256 cellar: :any,                 sonoma:        "9fcea2765f909283a7eecf6386b2f01909ef01bfcc350bc598c7e5a4fd03faf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c05433a61d83381856df0ca35cc8691136d48d9122a9423235e66acb2faab0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a79bfe8b23309c2d5de2cec6e353ff2da0b1010f609c2b0555151d2c531520"
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
