class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.0.8.tar.gz"
    sha256 "c722e1c96eb6775962ed250fdbd443357beed386ae3587534cf1835dcf604b66"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.0.8.tar.gz"
      sha256 "f8c0168a3e8454b6faf8e996fb074dd26bf161362168d316ebb22bb173fa2251"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7479a40168782d22bc1e720262d8ccd788c675326e573899a22d0b689c15338"
    sha256 cellar: :any,                 arm64_ventura:  "12c6cf854272ea00194dad24f578a8b725707a5e9509d5d4d79ddb569dd83ecf"
    sha256 cellar: :any,                 arm64_monterey: "3926e7204dcf90eba7487b9c4dc0b556dc6d92e0a52c04cc6f5e7c08b039eff9"
    sha256 cellar: :any,                 arm64_big_sur:  "c4420fbfa747752c5f8b3759b16c72fc34bbe59d0095387ab5743dac5a8db0cb"
    sha256 cellar: :any,                 sonoma:         "ac539927d257d3ac43cf8677871452403186761ba2380af6901feb6312665915"
    sha256 cellar: :any,                 ventura:        "b15f5455adbf4397672143f3de34bf03b07043d5a41a0659d1a0460e222c952c"
    sha256 cellar: :any,                 monterey:       "535258117bec6ca6b5009134237dde0f60f7cc795a94143e3ad3d109f75b5459"
    sha256 cellar: :any,                 big_sur:        "a2ed96e748f449af58fb052b3ab065c3838bd4d3890d5295fe58f0fd4513e00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a428d24df422c00c47625f060b93e86e175d19ea51c23582150479eff96bac"
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
