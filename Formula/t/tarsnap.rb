class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz"
  sha256 "bccae5380c1c1d6be25dccfb7c2eaa8364ba3401aafaee61e3c5574203c27fd5"
  license "0BSD"
  revision 1

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "ee097bdaecb43df24fdd6c40cd401cebc24ab36382547310da9a0b7320528a98"
    sha256 cellar: :any,                 arm64_sonoma:   "b6625d85533017b32de38a4691da1c7784917f77db503cf64ca960f912665168"
    sha256 cellar: :any,                 arm64_ventura:  "b9efb41f22d2bfc464a999b1008d98638c4c98960c41436253a6bae8f3b0bae9"
    sha256 cellar: :any,                 arm64_monterey: "b46cd4c9c74a74f0eda24f0b3128c174e6feb8c25258a71c3585063bfaea7ae1"
    sha256 cellar: :any,                 sonoma:         "587aa5a6354166253aac40af29637dfcf15a453e02a8c51d7099f7303db59167"
    sha256 cellar: :any,                 ventura:        "77b98ad1864065a20bb42234dc3d48a0fd1e1f4d3e03e945d2b6afacdcde459a"
    sha256 cellar: :any,                 monterey:       "9a557a13fa81c228758cef671dccd14d5d37e84672a4c83e38c2deeb4b28df6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7587b23f9faee15f4d9c7e4a89b4d38913dbc80d297b490f3738ad52ec60798a"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
  end

  # Needed for tarsnap 1.0.40; should not be needed for 1.0.41 or higher
  patch do
    url "https://github.com/Tarsnap/tarsnap/commit/4af6d8350ab53d0f1f3104ce3d9072c2d5f9ef7a.patch?full_index=1"
    sha256 "4136b5643e25f7d5e454c014b3c13d7ad015a02e796c5c91b3e4eeca28c1556e"
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
