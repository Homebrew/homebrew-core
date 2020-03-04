class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.4.5.tar.gz"
  sha256 "1badbab7e98a471c0d2a845db0278dd077e2fd1857434f271ef2b82798620f11"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5c7b9610572b1abce840e9cf88e5232771ea76559fb49776c87f3176f3c8815" => :catalina
    sha256 "9ab6a02da1750fb8deeefdadcab791017aea85b5921747af01c607c4e44e7eca" => :mojave
    sha256 "ac9e81e17df37c76f9f0db9218235b614a71d52442c961049f727062ace7c5fa" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]

  def install
    cd "native/src" do
      system "cmake", "-DSEAL_LIB_BUILD_TYPE=SHARED", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "native/examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    system "cmake", "examples"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
