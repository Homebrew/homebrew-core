class RaxmlNg < Formula
  desc "RAxML Next Generation: faster, easier-to-use and more flexible"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/"
  url "https://github.com/amkozlov/raxml-ng.git",
      tag:      "1.0.2",
      revision: "411611611793e53c992717d869ca64370f2e4789"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, big_sur:  "549ebe02f250cc28377df782326ba655b058bb942b1ebd8837557df1540c2fff"
    sha256 cellar: :any, catalina: "1cda64ccb9691d92434d397017a762910352c9cbac678efa1d92228b449a0d67"
    sha256 cellar: :any, mojave:   "906ac3867d84dbbddeac1f2b670fd0ce3abc6534af8969fb58a3ec13950691e7"
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
