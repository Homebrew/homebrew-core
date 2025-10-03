class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c850299c3c495221818a85c9205c60185c8ed9468d5ec2ed034470bb852229dc"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a24d3855da2af735455696a4cf8e41dac8acab4926de40d26097086ffb4e6c33"
    sha256 cellar: :any,                 arm64_sequoia: "8feff85967f3147f174f965ab1aaadee620fdcdfb8a7f1292613b35b552cf717"
    sha256 cellar: :any,                 arm64_sonoma:  "646a0fe583346a08a86b7d4b4f9af547b762ee01d7dc108d3c5436c7fdb1d09b"
    sha256 cellar: :any,                 arm64_ventura: "3710a4010ff9ae3a7d23e3299d591a04edf0489a73d85830f53ac287be9095c8"
    sha256 cellar: :any,                 sonoma:        "f2809f7561299cec3e859f6a7bb51c23144f1d16f271e1ce3f7ed19a9815c67f"
    sha256 cellar: :any,                 ventura:       "d2f97126da85f553513b6548d0250ce1c9214dcca8633aa839ab2b9924bbf422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498836e6beff84a9a7068c96323e36ed257ca6552106a6c35730fd45e229bd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb45c34d01eb2533ba080600ae58484c26015e136fb8bdad5f11f6dcdbbe93a6"
  end

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
