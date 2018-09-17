class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.21.tar.gz"
  sha256 "185c97e38b00edf6f5dea3dfc48c5c0e3e8386f6ad2d815a2b93b72998d509f2"

  bottle do
    cellar :any
    sha256 "f6a06e197e6d4b466a1d1f11f2505dc3c46b97370ae46cdbe008472006db8369" => :mojave
    sha256 "e265f9098008e2bf26e2f1b1e5ca1e5ec7309575a98f0eac9cb73aa2273896a0" => :high_sierra
    sha256 "cafc8e6f65cebd1c01f90adb18bc481efa5b8b3d4acf4c0f122940c6088192ba" => :sierra
    sha256 "7665a3c6b50383b20369c304038df2c75c874229cc79bf96bdd4c12c2efa937f" => :el_capitan
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
