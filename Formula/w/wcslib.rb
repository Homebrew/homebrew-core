class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/computing/software/wcs/"
  url "https://www.atnf.csiro.au/computing/software/wcs/wcslib-8.4.tar.bz2"
  sha256 "960b844426d14a8b53cdeed78258aa9288cded99a7732c0667c64fa6a50126dc"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?wcslib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d54f21bc3eef658e481d55ae6fc5c84faf09b8313282a2d52b0ba6041f43ca2"
    sha256 cellar: :any,                 arm64_sequoia: "9b4c893d06fdc0f35e6d0068cd2c0f8e310bcc21fcd80242c8096895ef6bbdc5"
    sha256 cellar: :any,                 arm64_sonoma:  "9d19f46e3c4eccaf8a8f0e47b15650a0d597fb7b1a0e41523f98c225733f79cd"
    sha256 cellar: :any,                 arm64_ventura: "a8a2219881ba618ed874d2d8e398c6014e0acc2a8116f2786fa44354950d0050"
    sha256 cellar: :any,                 sonoma:        "1e11d5347b5aabd5a8be7b58f255b296b32a27daea37dd6f1c96d58e05a099f9"
    sha256 cellar: :any,                 ventura:       "7ad6caa1fcc73ee40853218467f7c69063672b81c9f57168c2fc3fe36a352581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37620e6e7dea1408c2655d1f978f89186948f15b708109d33ca091c8f4cd0fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4796b96042e9131506aaacb702c1e6cb372fddc463b0e328b5f46ea49bf342"
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + (" "*20) + "T / comment" + (" "*40) + "END" + (" "*2797)
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end
