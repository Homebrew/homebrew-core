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
    sha256 cellar: :any,                 arm64_sonoma:   "5bc5d225da76c6e57a12ebe4027e454a2c2bfb3229306daac46df538d446b057"
    sha256 cellar: :any,                 arm64_ventura:  "4faeeca177bf726e5650f714fa64ceb56c8ce80ef3eaf652ae14dd44038ae42c"
    sha256 cellar: :any,                 arm64_monterey: "89218c6322857efe88d4efe757d6126b39ece00445fee8af52d9cdff1da2d1c7"
    sha256 cellar: :any,                 sonoma:         "47548e36720f03d2733188779bf9ba735e62c0fe5515d541c3bde330f01e0802"
    sha256 cellar: :any,                 ventura:        "de7883c9c8c5ce4f4f326c51e6e68ef1935cd0486e09324d20da4ba84d4ac9fe"
    sha256 cellar: :any,                 monterey:       "b6167481dee77e6372e7743f673cd0d3146b9ae478ecee9a28ac006cd863b3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166edd71fecff71213c8b68992872518600c0cc16aeec8de5ed83cc0ec002174"
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
    assert_equal version, resource("ncbi-vdb").version, "`ncbi-vdb` resource needs updating!" if build.stable?

    # For testing purposes, generate a sample config noninteractively in lieu of running vdb-config --interactive
    # See upstream issue: https://github.com/ncbi/sra-tools/issues/291
    require "securerandom"
    mkdir ".ncbi"
    (testpath/".ncbi/user-settings.mkfg").write "/LIBS/GUID = \"#{SecureRandom.uuid}\"\n"

    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
