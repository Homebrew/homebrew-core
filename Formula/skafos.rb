class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.4.0.tar.gz"
  sha256 "9defd32c0d8f2265ea003b7b3ce54fdb625ed54a11376f637ff9bdcd8501981d"

  bottle do
    cellar :any
    sha256 "3f0692ef59f51734b287da75ad74287734b4809896340d00a3d8b5bc88caafe3" => :high_sierra
    sha256 "8702f68fbd42af7bd9d8f75837e94747aeb15985316fb7c6d024cf2d79ed2a4a" => :sierra
    sha256 "ae153d80c0a00fc11bbb12ec6721fbd5681f7f869f9703bc85db450743845fb3" => :el_capitan
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
