class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-1.4.4.tar.gz"
  sha256 "7efa9347490e04bc22b4e62bed36864be1ba31bf8558d598cab57ef5096f2c02"

  bottle do
    cellar :any
    sha256 "9621195e9c7b6f019f83cc82f75099cd09a980f483784f2bfb8506fbeb9d4634" => :high_sierra
    sha256 "829b0c2b6d9d2452dc2e31f13d0f7105e28d40452b12f400b0365a89cdfaf1f4" => :sierra
    sha256 "0ca2e4610cdee2171357af542fcc4540a69a0336e278e0e5a30ee7748be174a0" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse

  def install
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
