class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://sunsite.icm.edu.pl/pub/unix/news/tin/v2.6/tin-2.6.4.tar.xz"
  sha256 "c66a1e8db30ddabe7e3313e6870f7877fe20f0da99afb65db3d8c41012fe55f7"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "37d09deb544531a4da9a4cf852ca5dbd7f09cd02fd8b87f7344218ee6b5bbac5"
    sha256                               arm64_sequoia: "3d597df858bc4fffb3f8be38154eaf650d981fbd36a609e1a0eb8b1113a01086"
    sha256                               arm64_sonoma:  "e729c23660a5a51cb38391405c50fec69f2713c8517e319e4f425894ac1d98c5"
    sha256                               arm64_ventura: "0bab093b5385450e3f87471243afe4b341443a141b971f5a02f7ad82a161f13b"
    sha256                               sonoma:        "b426577ee9e85591383eb389a0b2077228699af99fe7f7fdf5cc942f8b486264"
    sha256                               ventura:       "e9ee890eefb1b3cdde1c3c4420fab41c632163b30ce7429d74a67bf03b092fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59fbbd067f08e1c809d0eac35d969b80b53dddddd7b0e447a06b3a33ad785727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da69315726b0f03dd42918f5e545befd3afc660d08f2b6ec70f1a651c421abb"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    rm_r buildpath/"pcre"

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-pcre2-config=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config"
    system "make", "build"
    system "make", "install"
  end

  test do
    system bin/"tin", "-H"
  end
end
