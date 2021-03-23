class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.11.0.tar.gz"
  sha256 "10ac0a4d1fafc274bc107de811891d3e803d0713a247581dece4448231883810"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2e6ba6ca7df3d84b405aa1f2f8f198a30428ad7c8b4b0e4f17c9b90499851e94"
    sha256 cellar: :any_skip_relocation, catalina: "4a0110b9f08743369503f72bbfcd24aec64f87a820e61ad75652f85ea058203d"
    sha256 cellar: :any_skip_relocation, mojave:   "bf46b5e1ba3fb51cc2ef92dd6bc3a3b30946cf505fb3c5262b826e04c5a09604"
  end

  depends_on "hdf5"
  depends_on "libmagic"

  uses_from_macos "libxml2"
  uses_from_macos "perl"

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/2.11.0.tar.gz"
    sha256 "5fde50784760c00b403c2cc42ead15a4e9477697ee439f0a16edb4de3f52dfcc"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.11.0.tar.gz"
    sha256 "9a65e3885b9ae1ebecbec871f04ce3162ac3764fb556ecdc8c1e61993e2164aa"
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
    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
