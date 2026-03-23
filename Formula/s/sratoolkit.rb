class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.4.0.tar.gz"
    sha256 "6f60984a212d35b239244c23b9686e2a1131c76b92f0c41e8b56d3f5b6fff2d0"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.4.0.tar.gz"
      sha256 "ff7f49994620d2453043ccfcff1eb7d376bb6ab5402eaae127497a94b4a210b2"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0290de3cbea5db235065149d91c67338897a39679b65e0ca5b1875d139bd292"
    sha256 cellar: :any,                 arm64_sequoia: "a7bb204779fe03d2ea6e25f646bc7b9c37b8b3e38af24ae7d977e3038cac89ce"
    sha256 cellar: :any,                 arm64_sonoma:  "60d5a6e64d8648ea20b3499c66a0cc9f885e272a6be9c0499321e0e4c5716be8"
    sha256 cellar: :any,                 sonoma:        "e186fbaa4b6dbd3e874615f5830837b776a4821c9980d2d851e2099516db6820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110291bb50879dfd90c5be51eda28de8ab22395d214ac0fc41b59fbc42e89658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78d4198b2666232baa704d10e4ef961dfeb5ee7bde14a31486b77e2ea84e720"
  end

  head do
    url "https://github.com/ncbi/sra-tools.git", branch: "master"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

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
