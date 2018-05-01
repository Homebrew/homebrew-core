class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.0.tar.gz"
  sha256 "96064f7edb7f7671587a928bd2f7e54d82f5c763e12c8c56dca8d0dff8dd5db8"

  bottle do
    cellar :any
    sha256 "17d972e1acbe6fbfc559989f3896a9ee02538d910f34087b6f64987a2d1b7bb8" => :high_sierra
    sha256 "d735bc79ff5c211cb47c3b63c220483ed66f9ab7b565d22205121436ee543343" => :sierra
    sha256 "feb17ec41d2a42fc7012fcdb0cac11d16c646bb85c2add643cf9db1583ab4bc2" => :el_capitan
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
