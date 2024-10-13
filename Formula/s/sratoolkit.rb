class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.1.1.tar.gz"
    sha256 "96b110bd5a30ad312e2f02552062b48a77d40c763e6aba5bb84e83662a505cf1"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.1.1.tar.gz"
      sha256 "e9766f259853c696be48e289b08cb5ae6e198d82d7ffee79f09ce7f720487991"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9d051a20976c9212f9b57d78fbd7043d6c03380c598757c147b0fe3f8364c646"
    sha256 cellar: :any,                 arm64_sonoma:   "8b6581068ebb4d42908bed8f9be8fe44f896483d7f19cb15107ab315294513ef"
    sha256 cellar: :any,                 arm64_ventura:  "edf975289e9caef050ae49d59b2b677d44483b49583977175514422135eae15d"
    sha256 cellar: :any,                 arm64_monterey: "7dcf55c2e3ac299e2cecb44d71dcb1f0c50badeac8169076288217d4ce19187f"
    sha256 cellar: :any,                 sonoma:         "9e2e37314105274979ba40b006398cff75639fc0cbda5508d50f7b9f69ac10bf"
    sha256 cellar: :any,                 ventura:        "d2b5f395687e8546a3a85409aa307f15c7ae4c72d5aca87c6b98b4ca3c27193a"
    sha256 cellar: :any,                 monterey:       "466af9c6aa160bb2be60fa1b4e57de7a00a7104cf70cce89eaa5a3705c7169e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4562ca1d63b5f4638dd94c2d99e8254cb7b8703e32d754f30ce4f23e1e96492"
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
    rm_r(bin/"ncbi")
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
