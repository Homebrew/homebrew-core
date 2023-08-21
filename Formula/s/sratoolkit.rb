class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.6.tar.gz"
    sha256 "9fecfd819ee9beaf8a1d3e4b76a5d49e747bc064525b40416e0730a168986348"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.6.tar.gz"
      sha256 "4b6f93336bf8664fdcc151d41ea0793f0b0f88cfcb7c2aa049f162a72f905223"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b92a302781a442d304744e73a3dfcc430b28cd98345cdf7804a8826cd57958cf"
    sha256 cellar: :any,                 arm64_monterey: "d588b8270bb3ffbca8384800815e3e0f8b160f234a2f0b0a0d4948f1fd496ed9"
    sha256 cellar: :any,                 arm64_big_sur:  "c57ea65e2950af90ad91049d7ef129fb969e08024b8a5267550f77e8db17c48e"
    sha256 cellar: :any,                 ventura:        "163f0676075d90dfb25ab1a540174a720f0528127d0a7c6709d033f71ad01c16"
    sha256 cellar: :any,                 monterey:       "1d318aa1a7673d0e72d2b1f7655128f09cd7122dc52c6f46f06b874d723e97d2"
    sha256 cellar: :any,                 big_sur:        "daaf2761b2728f623968bae056e352c8d0e7eab533ae67f57a56806c0d47d965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe372d7886b54cb39c0376c50b9018aa3b936fd074d88280ea0fb4c68af8f7c"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on macos: :catalina

  uses_from_macos "libxml2"

  def install
    (buildpath/"ncbi-vdb-source").install resource("ncbi-vdb")

    # Workaround to allow clang/aarch64 build to use the gcc/arm64 directory
    # Issue ref: https://github.com/ncbi/ncbi-vdb/issues/65
    ln_s "../gcc/arm64", buildpath/"ncbi-vdb-source/interfaces/cc/clang/arm64" if Hardware::CPU.arm?

    # Need to use HDF 1.10 API: error: too few arguments to function call, expected 5, have 4
    # herr_t h5e = H5Oget_info_by_name( self->hdf5_handle, buffer, &obj_info, H5P_DEFAULT );
    ENV.append_to_cflags "-DH5_USE_110_API"

    system "cmake", "-S", "ncbi-vdb-source", "-B", "ncbi-vdb-build", *std_cmake_args,
                    "-DNGS_INCDIR=#{buildpath}/ngs/ngs-sdk"
    system "cmake", "--build", "ncbi-vdb-build"

    system "cmake", "-S", ".", "-B", "sra-tools-build", *std_cmake_args,
                    "-DVDB_BINDIR=#{buildpath}/ncbi-vdb-build",
                    "-DVDB_LIBDIR=#{buildpath}/ncbi-vdb-build/lib",
                    "-DVDB_INCDIR=#{buildpath}/ncbi-vdb-source/interfaces"
    system "cmake", "--build", "sra-tools-build"
    system "cmake", "--install", "sra-tools-build"

    # Remove non-executable files.
    (bin/"ncbi").rmtree
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
