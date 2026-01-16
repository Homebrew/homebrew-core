class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c850299c3c495221818a85c9205c60185c8ed9468d5ec2ed034470bb852229dc"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2c481a5e9c22baa108639438a9a73d383498d0740bc6737da4bbcb2c5baa50a"
    sha256 cellar: :any,                 arm64_sequoia: "66dcd09bdde2e8848334ac572ef1cf5e893350a4476de5a7437aabd8d6795be3"
    sha256 cellar: :any,                 arm64_sonoma:  "5ddca8d6a81ee2ce99ce56f9f3ae534e438ca10eaae1e845012ca009b2bf9d7d"
    sha256 cellar: :any,                 sonoma:        "be2a81baac1d393b70c57ab6cb6570bfebe4b97bd02cd1c33e9adc9886d52497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea93a7029e5a870cf2182aa6f313683f8ea8b13bbb0e91e19818c374680784ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eaf60a5353155dc333bc1ac5610b861275871aedb169b47d385fa0ee552caeb"
  end

  depends_on "htslib"
  depends_on "xz"

  # Backport library rename needed by dependents
  patch do
    url "https://github.com/vcflib/tabixpp/commit/4cebc981b35c67486e7454064c54cddf547fd58a.patch?full_index=1"
    sha256 "d08f2eb62fb7be5457adb4615c7fbda587993899e8d18a9b8ed0647144c8f3f9"
  end

  def install
    htslib_include = Formula["htslib"].opt_include
    args = %W[
      INCLUDES=-I#{htslib_include}
      HTS_HEADERS=#{htslib_include}/htslib/bgzf.h #{htslib_include}/htslib/tbx.h
      HTS_LIB=
      PREFIX=#{prefix}
      DESTDIR=
    ]
    args << "SLIB=libtabixpp.$(SOVERSION).dylib" if OS.mac?

    system "make", "install", *args
    lib.install_symlink shared_library("libtabixpp", version.major.to_s) => shared_library("libtabixpp")
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system bin/"tabix++", "test/vcf_file.vcf.gz"
    assert_path_exists "test/vcf_file.vcf.gz.tbi"
  end
end
