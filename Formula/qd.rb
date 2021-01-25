class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.22.tar.gz"
  sha256 "30c1ffe46b95a0e9fa91085949ee5fca85f97ff7b41cd5fe79f79bab730206d3"

  livecheck do
    url :homepage
    regex(/href=.*?qd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "380c30f837eed2027f1f1a353cfca4b5f71f551e504c26b2ab635cba4918681b" => :big_sur
    sha256 "a142fb3e68694ee7529043e985fd898069553ec2ca37483336b6ead7246e28bc" => :arm64_big_sur
    sha256 "9700e6163692f31c736ddd74f535305fef730e021c4ca9f85b5860926397e330" => :catalina
    sha256 "53e4efc8ab2d1c18b1c4198bed031eb1b97b4431b1c0a4e8e4195c9b01659098" => :mojave
    sha256 "0ff67d07426a90d2897f0f69da0bd91bedb8a40ea52c0201c80225dd6c22510d" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
