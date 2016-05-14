class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.17.tar.gz"
  sha256 "c58e276f6fcf5f2f442c525f3de42ea00004734572b29c74028bbda0ad81096d"

  bottle do
    cellar :any
    sha256 "02f2e11cae957f20fee46218a559368ac2c44cfdf6edd042c7430c3f5e3c5227" => :el_capitan
    sha256 "bd53e8612f09d48ffcfd9d981717e94ae5c617c08c0e2b0e8250ea085a75dd57" => :yosemite
    sha256 "35c7acae6a87c02301cde8c5d76b59bb696d9c3dd04970948c5fdbe3c1c6776e" => :mavericks
  end

  depends_on :fortran => :recommended

  def install
    args = ["--disable-dependency-tracking", "--enable-shared", "--prefix=#{prefix}"]
    args << "--enable-fortran=no" if build.without? :fortran
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
