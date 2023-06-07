class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.5.tar.gz"
    sha256 "6dca9889ca9cfa83e9ce1c39bf7ae5654576fc79c4f608e902272a49573a05e0"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.5.tar.gz"
      sha256 "a32672d7f76507a77ceb29f023855eaf5bf4d150ddd21b55c013b499f3b83735"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e39ce821d99c17565a552de1404ed7873b8a02598e8f1695aaa7c82a805400b2"
    sha256 cellar: :any,                 arm64_monterey: "7825264f83e3e5a6f67cf30b12407b817bf45e87f663a2d9d07df8e6c3767266"
    sha256 cellar: :any,                 arm64_big_sur:  "c85b2d9c44e5ddd29a89337dac54c3cf56de6acf0de1d090f09335bb5f759bf6"
    sha256 cellar: :any,                 ventura:        "9da5e99482d0124bbe7c0224292eadcba35ac50c4706878d1dd8e23cf701d232"
    sha256 cellar: :any,                 monterey:       "31c110af27ab2205771a2655a80cd683e2f031c4cb24e8d9b5316270fa53cd2c"
    sha256 cellar: :any,                 big_sur:        "7be4aa943eb98121a7d74db06a32814913fe24967f03e91b99ac126fa95bc119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bd79275259261f89478164f78849d996a086ae39c075d2a0dce05032f8fb5c"
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
