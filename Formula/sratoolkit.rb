class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.10.8.tar.gz"
  sha256 "4adb969a9a998f6a50020f99aa66f6ae27916f7dc83ddf6722fc0fea4a3a4d17"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f5dba15de1efbf19142a6c89e8c3c1c8cb4e081ba3375d66536b1af3381645f" => :catalina
    sha256 "49c589cf081c862f544b346b1e6878c5ab6d9a01b8a8582b054d61b153136199" => :mojave
    sha256 "0e8fd8c3dca32ab66080dccc7050d1fefff0802809217b695cb888b79f5b2312" => :high_sierra
  end

  depends_on "hdf5"
  depends_on "libmagic"

  uses_from_macos "libxml2"
  uses_from_macos "perl"

  on_linux do
    depends_on "pkg-config" => :build

    resource "which" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Which-1.23.tar.gz"
      sha256 "b79dc2244b2d97b6f27167fc3b7799ef61a179040f3abd76ce1e0a3b0bc4e078"
    end

    resource "build" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Build-1.92.tar.gz"
      sha256 "cd95173a72e988bdd7270a22699e6c9764b6aed6e6c4c022c623b1ce72040a79"
    end

    resource "tiny" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Path-Tiny-0.108.tar.gz"
      sha256 "3c49482be2b3eb7ddd7e73a5b90cff648393f5d5de334ff126ce7a3632723ff5"
    end

    resource "chdir" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/File-chdir-0.1010.tar.gz"
      sha256 "efc121f40bd7a0f62f8ec9b8bc70f7f5409d81cd705e37008596c8efc4452b01"
    end

    resource "capture" do
      url "https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz"
      sha256 "6c23113e87bad393308c90a207013e505f659274736638d8c79bac9c67cc3e19"
    end

    resource "libxml2" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Alien-Libxml2-0.11.tar.gz"
      sha256 "aa583d8e7677f944476bd595e3a25a99935ba15ca0b6a50927951e2ab8415ff3"
    end

    resource "libxml" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0201.tar.gz"
      sha256 "e008700732502b3f1f0890696ec6e2dc70abf526cd710efd9ab7675cae199bc2"
    end
  end

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/2.10.8.tar.gz"
    sha256 "f20fae21439b69b6a3573c864a175e0f9aa47ca6dd12bea15e429b7c5a9b81b5"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.10.8.tar.gz"
    sha256 "7a593aa22584db9443bb56ac01409707bca01b8f9601fe530dac81b73f1a44df"
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
