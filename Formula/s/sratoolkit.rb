class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.7.tar.gz"
    sha256 "8c4f242e7540ccf94c9d145e40ae564ccd48a26a2e90c1453af4716a35ed1537"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.7.tar.gz"
      sha256 "357f9648e824ae860eb8433c04099d748b804d76bdcfd05e41857eee098869ee"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa59848b69343b613a42be050cd11e2d87c6f54ed18a80a672b71a76472a947d"
    sha256 cellar: :any,                 arm64_monterey: "27797a148ac8682d2c2ad19ef44f8a72753cff83bc1a6adb38185a4cad3f8c82"
    sha256 cellar: :any,                 arm64_big_sur:  "1634ec0f73e6be3119a2d6f761cd689e80e3967f0e99255203b18ed821228e72"
    sha256 cellar: :any,                 ventura:        "edc413e6ebe8bce65d1ea67cf42fae5bd4f43bc57ca7f2961001ad854fb709a3"
    sha256 cellar: :any,                 monterey:       "78d71d67598307b8bbbb220ddd4beaeca2b73c886a118c98038c341e7b46f7d1"
    sha256 cellar: :any,                 big_sur:        "d85b13b985b124c60dfae7161eba16693301ee5e322740f320683c6962a5401c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea423d330754acedbac185dad6f9bf3c41b98886e4c0b144934ea7b94da5c29b"
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
