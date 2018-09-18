class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.0.tar.gz"
  sha256 "2f1da1bc6c1452b10fe9ecc738cfde6ddd35ec58fc24f8a511da8efefeab5ab0"

  bottle do
    cellar :any
    sha256 "aff1c7b8c32ea76e8daf3fab0cc67fd3d8706dff8d3251e08c7f66d04fc6bddd" => :mojave
    sha256 "e7393b659b619c29eaa18d2cb856b68b2936cf0d70587a5b4fcbb3d3c0a9ba11" => :high_sierra
    sha256 "d1f46fdebb1f6b963fa2b155048e096b67e72429f6b3240d50faa4e47484dc68" => :sierra
    sha256 "d4a3ca0ab54e6ca489621151fc55a5ef4d0dd70f772f8c071087cdb1df4449ac" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libarchive"
  depends_on "yaml-cpp"

  def install
    system "make", "_create_version_h"
    system "make", "_env_for_prod"

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/skafos setup
      set timeout 5
        expect {
          timeout { exit 1 }
          "Please enter email:"
        }
        send "me@foo.bar\r"
        expect {
          timeout { exit 2 }
          "Please enter password:"
        }
      send "1234\r"
      expect {
        timeout { exit 3 }
        eof
      }
    EOS
    assert_match "Invalid email or password", shell_output("expect -f test.exp")
  end
end
