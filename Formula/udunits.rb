class Udunits < Formula
  desc "Unidata unit conversion library"
  homepage "https://www.unidata.ucar.edu/software/udunits/"
  url "https://artifacts.unidata.ucar.edu/repository/downloads-udunits/udunits-2.2.28.tar.gz"
  sha256 "590baec83161a3fd62c00efa66f6113cec8a7c461e3f61a5182167e0cc5d579e"

  livecheck do
    url "https://artifacts.unidata.ucar.edu/service/rest/repository/browse/downloads-udunits/"
    regex(%r{href=.*?/udunits[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "11fbb852b729b417f5c3cca75fcf53b30e5e662638ddac30c59c699e04ae7c75"
    sha256 big_sur:       "98494853cf3c9763f511e3f4d1daddd29cbcf8c8a91c4716ed5951e081753bad"
    sha256 catalina:      "b325949e293c7e881bb468893a84e75283587af9ccd21595874eec515d778b9c"
    sha256 mojave:        "4994ec2de43dcff6c6b74b3d7ec053cac4ad475b8c4b95207e7c8b999b43f884"
    sha256 x86_64_linux:  "e05daef7e7f7ad70952a77ac4096e5a72f201c04be9c78b3c684b9846ab4cb9d"
  end

  head do
    url "https://github.com/Unidata/UDUNITS-2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"

  def install
    system "autoreconf", "--verbose", "--install", "--force" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match(/1 kg = 1000 g/, shell_output("#{bin}/udunits2 -H kg -W g"))
  end
end
