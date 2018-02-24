class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.9.0.tar.gz"
  sha256 "fbdbbf69cf95afca311b9759e14a991dafcb95549ffd5e2e21fb0ecc99fa06aa"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "c7f266cafb38da2d4a97f7dd55495bffaee1b4de10dabfff0cd2169feb294c92" => :high_sierra
    sha256 "77c82b91cc83271178381d0787d7f0242cb56c44119c9e07426c25dea7a2e689" => :sierra
    sha256 "3ce0a6f82a5b18b891adac99f1fedf1a941e54356989d8e076bbe7df17b62dc0" => :el_capitan
  end

  depends_on "hdf5"
  depends_on "libmagic"

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/2.9.0.tar.gz"
    sha256 "7e4f9e4490309b6fb33ec9370e5202ad446b10b75c323ba8226c29ca364a0857"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.9.0.tar.gz"
    sha256 "40fdd0a34592f76bdad174d3c2b57b3efcd1e2240512a383bd6e6263b33a6146"
  end

  def install
    ngs_sdk_prefix = buildpath/"ngs-sdk-prefix"
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure",
          "--prefix=#{ngs_sdk_prefix}",
          "--build=#{buildpath}/ngs-sdk-build"
        system "make"
        system "make", "install"
      end
    end

    ncbi_vdb_source = buildpath/"ncbi-vdb-source"
    ncbi_vdb_build = buildpath/"ncbi-vdb-build"
    ncbi_vdb_source.install resource("ncbi-vdb")
    cd ncbi_vdb_source do
      system "./configure",
        "--prefix=#{buildpath/"ncbi-vdb-prefix"}",
        "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
        "--build=#{ncbi_vdb_build}"
      ENV.deparallelize { system "make" }
    end

    # Fix the error: ld: library not found for -lmagic-static
    # Upstream PR: https://github.com/ncbi/sra-tools/pull/105
    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    system "./configure",
      "--prefix=#{prefix}",
      "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
      "--with-ncbi-vdb-sources=#{ncbi_vdb_source}",
      "--with-ncbi-vdb-build=#{ncbi_vdb_build}",
      "--build=#{buildpath}/sra-tools-build"

    system "make", "install"

    # Remove non-executable files.
    rm_r [bin/"magic", bin/"ncbi"]
  end

  test do
    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
