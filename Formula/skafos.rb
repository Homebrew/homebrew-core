class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.2.tar.gz"
  sha256 "ed8191f7e099e5a51c5adaf8b829e8467de71d9e1de225ba18aa435b2fcb6249"

  bottle do
    cellar :any
    sha256 "f0aad13b746f15dae682a6e13a291dc0b957b3644238f918da0e8c4492b7aa21" => :high_sierra
    sha256 "f89808d3a0ef281e405bbdb1cc6981334703d5781708b686850ff7df3d8d2bea" => :sierra
    sha256 "71e76d0a80c6f49af1679d2809f7b5e8c8bd4117b17d5367ad5b9749186adc7e" => :el_capitan
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
