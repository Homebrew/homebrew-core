class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz"
  sha256 "bccae5380c1c1d6be25dccfb7c2eaa8364ba3401aafaee61e3c5574203c27fd5"
  license "0BSD"

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "fa9edee032f8abbc50104c8811279d8b120a911ecc5091a281b6a46a2a234f92"
    sha256 cellar: :any,                 arm64_monterey: "2f85cb28a47e95f3c56f4e8f46fd0dbc93fd08e4bba009316496d0cfbcbf97c7"
    sha256 cellar: :any,                 arm64_big_sur:  "1568e243b45336f4056edd5b318089467241896d2e61495cc96d0ad69cdf3faf"
    sha256 cellar: :any,                 ventura:        "729e037c57f531035fe9415eb15c0f3f9b7b137869945de8a2109ea53a0d8583"
    sha256 cellar: :any,                 monterey:       "f63b7b06c773b38efe542a851cd978b21019c2387c54afb63be12b4341637e30"
    sha256 cellar: :any,                 big_sur:        "d5e0ed53466a5fe9b2a0be1cc1870ca6a98a06a34068ea6549b57de7b7a1862e"
    sha256 cellar: :any,                 catalina:       "4240cae3fe32207826e333930377408f7832a4404fd033d6cba331d56cd98c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d95c422ceceb7439b60c44c9412639deb8eb9a9a9a5c539fdb3a164cc11e0e92"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
