class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.7.tar.gz"
  sha256 "8c1c49a1eccf5d8b952dadadba3552b0eac67482b8a29eaad62aa7343a0732c3"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "a3ce513ca71645a6c71d3f5b0e60ccb27171a8b9a019287e170efe817fb4a76b" => :catalina
    sha256 "3f0eb432537467e69e9e4990ab6511b795c68557ab276d9e11325ece14c68718" => :mojave
    sha256 "4cfd76bc84c1b51b2d1450560eb67f1b467c1ebba516c84e617cc099ff579ee7" => :high_sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    system "python3", "scripts/mk_make.py",
                      "--prefix=#{prefix}",
                      "--python",
                      "--pypkgdir=#{lib}/python#{xy}/site-packages",
                      "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
