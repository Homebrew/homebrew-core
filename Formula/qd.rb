class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.18.tar.gz"
  sha256 "81096b5b33519cbeed5fc8ef58e1d47ee8f546382514849967627b972483716e"

  bottle do
    cellar :any
    sha256 "0521889565734afc8faa992fbaa7735f934e6ba9a758e11760c8a0cb150dba3f" => :high_sierra
    sha256 "a1354aeb2b037bd7c201f454e15beb266990355b617309fcf383bea6ac3f67b2" => :sierra
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
