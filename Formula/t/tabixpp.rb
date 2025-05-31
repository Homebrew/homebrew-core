class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c850299c3c495221818a85c9205c60185c8ed9468d5ec2ed034470bb852229dc"
  license "MIT"

  depends_on "htslib"
  depends_on "xz"

  def install
    htslib_include = Formula["htslib"].opt_include
    args = %W[
      INCLUDES=-I#{htslib_include}
      HTS_HEADERS=#{htslib_include}/htslib/bgzf.h #{htslib_include}/htslib/tbx.h
      HTS_LIB=
      PREFIX=#{prefix}
      DESTDIR=
      SLIB=
    ]
    system "make", "install", *args
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system bin/"tabix++", "test/vcf_file.vcf.gz"
    assert_path_exists "test/vcf_file.vcf.gz.tbi"
  end
end
