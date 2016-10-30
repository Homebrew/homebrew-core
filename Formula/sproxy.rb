class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "https://www.joedog.org/sproxy-home/"
  url "http://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "8d57317644b76b465adc5caf984f1e3cf57f9486f642705eee66128adbcf3589" => :sierra
    sha256 "4ed786b0b05ca3c88d5904e3119d84725a9f9bedf5d952c055f22a81661a825c" => :el_capitan
    sha256 "19da9a5b680a860e721ec60763dd48e9a5213505ee643703abcdc66707e8ce51" => :yosemite
    sha256 "96b9cdebf5a11907998ba33e2b568fd5a77d46261a6faaa9c33a5d8eeca9a27f" => :mavericks
  end

  # Only needed due to the change to "Makefile.am"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Prevents "ERROR: Can't create '/usr/local/share/man/man3'"; also fixes an
    # audit violation triggered if the man page is installed in #{prefix}/man.
    # After making the change below and running autoreconf, the default ends up
    # being the same as #{man}, so there's no need for us to pass --mandir to
    # configure, though, as a result of this change, that flag would be honored.
    # Reported 10th May 2016 to https://www.joedog.org/support/
    inreplace "doc/Makefile.am", "$(prefix)/man", "$(mandir)"
    inreplace "lib/Makefile.am", "Makefile.PL", "Makefile.PL PREFIX=$(prefix)"

    # Only needed due to the change to "Makefile.am"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "SPROXY v#{version}-", shell_output("#{bin}/sproxy -V")
  end
end
