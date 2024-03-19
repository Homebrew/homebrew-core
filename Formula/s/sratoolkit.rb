class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.1.0.tar.gz"
    sha256 "ce92ce887ee4a7581a7511cfb6b965ac6a5e38841bad9be66a3aee903ec48952"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.1.0.tar.gz"
      sha256 "eec5a64b8353a201bd4cf2c58cfcbb3622327397c3b11696ae59d827fcfcea9d"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "288593bcf0575573268e77acde718503276d5cccadeffd2d0ff66b11cc4ddca5"
    sha256 cellar: :any,                 arm64_ventura:  "59d8efcb1ea6b8f657118e070a026ec94f5ad9ea65fc5171d8b6ec07b4cb7bd9"
    sha256 cellar: :any,                 arm64_monterey: "6812a2fd32f4d8b03db44b1a5e3760ea0f8200669b2d7202145664eea4b8f153"
    sha256 cellar: :any,                 sonoma:         "95d35ce273d086ce6dccb4e49d848f9c673402450d5b63af891523fca25e107a"
    sha256 cellar: :any,                 ventura:        "58394b0a5d9afc9fc5d3fa2d009ff08fcd1ee443b8dc0f67219af3f60c94bf73"
    sha256 cellar: :any,                 monterey:       "2ba8fb930bf41bacb15ec3d9b306cffaa0857bd2fd3a0a0faca593b424f4736d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca03db4cccca29859f3af227953235ebfb7d23a4287f3cfd130a1b410c5f9386"
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
    odie "ncbi-vdb resource needs to be updated" if build.stable? && version != resource("ncbi-vdb").version

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
