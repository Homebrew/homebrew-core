class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  license all_of: [:public_domain, "GPL-3.0-or-later", "MIT"]

  stable do
    url "https://github.com/ncbi/sra-tools/archive/refs/tags/3.2.0.tar.gz"
    sha256 "5ed9d0a61aa72c55566fb80b8b9293ad9006f528e7e11cba875d9377a0fc7b09"

    resource "ncbi-vdb" do
      url "https://github.com/ncbi/ncbi-vdb/archive/refs/tags/3.2.0.tar.gz"
      sha256 "49fea92d9ec5ab38a5c06d1bcb057d1e7c9d4d39adcb7f31a3485ecc35bd5b77"

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
    sha256 cellar: :any,                 arm64_sequoia: "4663526c841e3113fd1c8645c18de2b564235361f9591ffc2e5e364b2a13d80e"
    sha256 cellar: :any,                 arm64_sonoma:  "55b800dbf333fb8f2103e09a7fff8f55c7606967240b468809942eeca4ab7495"
    sha256 cellar: :any,                 arm64_ventura: "954df5933e11e8f7df526c4f5c9b98fad3fccad4cc4606811db7c7c1712e2319"
    sha256 cellar: :any,                 sonoma:        "6232abb46acf7b280ee4fc8c2fbe0b9c22f1a6b18b4ca2d5509f9d3265cdd2c3"
    sha256 cellar: :any,                 ventura:       "2f507a6c133a2bea1ddb20e132e6878d6ad670213a0ad1eb7e0697990059d813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "868b24e81e0d963891c514871ae75fd00b88351b5eb48c6702bc07c92576329a"
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
