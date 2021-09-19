class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "https://www.joedog.org/sproxy-home/"
  url "http://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"

  livecheck do
    url "http://download.joedog.org/sproxy/"
    regex(/href=.*?sproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2558b7f1308c8bc08667c8e51d40b1c8df05280fa8c5f003f6dec07561089c2e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0feb23f8381e7e40ce846974be822ba97d42658a721582320468355193dc4851"
    sha256 cellar: :any_skip_relocation, catalina:      "ee0bff8062b0d007a9b762d35af1879e8abcf7203dae265d1a70ade53047af90"
    sha256 cellar: :any_skip_relocation, mojave:        "2d689087925622e4f7e2c2572c2339c62a6c2b891bce7093bcd664f1a15c28d9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "326b01fa9a1370c54929ae4c11d1b67b2238875eca8188365486b9c2a374264f"
    sha256 cellar: :any_skip_relocation, sierra:        "8d57317644b76b465adc5caf984f1e3cf57f9486f642705eee66128adbcf3589"
    sha256 cellar: :any_skip_relocation, el_capitan:    "4ed786b0b05ca3c88d5904e3119d84725a9f9bedf5d952c055f22a81661a825c"
    sha256 cellar: :any_skip_relocation, yosemite:      "19da9a5b680a860e721ec60763dd48e9a5213505ee643703abcdc66707e8ce51"
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
