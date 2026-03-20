class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://sunsite.icm.edu.pl/pub/unix/news/tin/v2.6/tin-2.6.5.tar.xz"
  sha256 "91384d133d72671863494dd9742bc622b4089ea8ea760884a5b8c34095d76dc5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "96069ba7501f4b095fa09d2cb6b60e6e3c613ca546422cf8c5cbac897947d1e4"
    sha256                               arm64_sequoia: "205f564b17a2d485cdbecda830945eda2074f80f51ea235f967ac43161c193ff"
    sha256                               arm64_sonoma:  "75e3cae279ac058854a43d4d83b0d0dceba012427bb0da4c38bfdaff33d50f14"
    sha256                               sonoma:        "5240d4c495d46cdcc73409c3ba63bb3a16244defa0cdc24174c2ac2baffe2b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48098319c7de44f58c85885af2cede333bb309c9f663b86cf59f6635e86b92af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ab2a4d9691671a8b512319dc59c3cc4112ddb678a5b3079722fdec7cbd601e"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    rm_r buildpath/"pcre"

    system "./configure", "--mandir=#{man}",
                          "--with-pcre2-config=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config",
                          *std_configure_args
    system "make", "build"
    system "make", "install"
  end

  test do
    system bin/"tin", "-H"
  end
end
