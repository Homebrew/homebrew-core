class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.4.5.tar.gz"
  sha256 "1badbab7e98a471c0d2a845db0278dd077e2fd1857434f271ef2b82798620f11"

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
