class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.0.3",
      revision: "55aeb1c38cfda54cfd9a416b30a87f08b15a94e5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 monterey:     "822c606a5d0cfb5efc0fccd2f138ffe5058518bc62bad537cf4e5448493f9447"
    sha256 cellar: :any,                 big_sur:      "53b34f6c99ec604321d1314e5e6b94c559347c168e1702f0a23f93fc8a75c0e7"
    sha256 cellar: :any,                 catalina:     "365081db70aff0f633a8af24cc85b222b06ae3eb73fbadabd9c8c292e388a6b8"
    sha256 cellar: :any,                 mojave:       "05bfd69c3d218af9a44cbcf2f2d7e007d431aa8e45519a7ead14b67945df3666"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "526f8a8bd9d0d15a7e427f950a86aa37aaa376a29d6a3c15e6781bbb36bdafde"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "open-mpi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  resource "example" do
    url "https://sco.h-its.org/exelixis/resource/download/hands-on/dna.phy"
    sha256 "c2adc42823313831b97af76b3b1503b84573f10d9d0d563be5815cde0effe0c2"
  end

  def install
    args = std_cmake_args + ["-DUSE_GMP=ON"]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
    mkdir "build_mpi" do
      ENV["CC"] = "mpicc"
      ENV["CXX"] = "mpicxx"
      system "cmake", "..", *args, "-DUSE_MPI=ON", "-DRAXML_BINARY_NAME=raxml-ng-mpi"
      system "make", "install"
    end
  end

  test do
    testpath.install resource("example")
    system "#{bin}/raxml-ng", "--msa", "dna.phy", "--start", "--model", "GTR"
  end
end
