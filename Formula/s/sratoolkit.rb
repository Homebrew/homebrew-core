class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.3.0.tar.gz"
    sha256 "3bfa26c5499a94d3b2a98eb65113bbb902f51dadef767c7c7247fc0175885a9a"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.3.0.tar.gz"
      sha256 "36b3467affd53bea794e3eeb5598619d820bc726dc68751a189181ac7973047d"

      livecheck do
        formula :parent
      end
    end

    # Backport fix for newer libxml2
    patch do
      url "https://github.com/ncbi/sra-tools/commit/e2b9d82b59c2636a1224995dbb7164c0b1391c77.patch?full_index=1"
      sha256 "47a5b9811ef4745ebce51a7c7ed794855131702d93e8272385d326ef9cd0c52f"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "159cc6b0addb50eac67eb61286eeceb03d14c50715fb440e9377fe8e555b7edf"
    sha256 cellar: :any,                 arm64_sequoia: "e66397ba8dc07da3cd6aae4959b958b2f61fe6bba6452e758283f3843ec07aae"
    sha256 cellar: :any,                 arm64_sonoma:  "bcf92778414d9e3d9b1099eb742be068175134d11c42110ab9d67fc94fdeae5b"
    sha256 cellar: :any,                 sonoma:        "25290dba86c7b7b2e9fc2b2d79d74db9dfa329d5ed7c4eaaa2bfdc43370bb716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b64ea9757dcd7c669a1b2f048beccdf68b8f1cab8ee360a6adfd65a1e91e8bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fae8a4dfcb3e32aa9e81d70d66759019f0fe5de66d5324e376bcce443a4d6a5"
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
