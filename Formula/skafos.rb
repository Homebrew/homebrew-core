class Skafos < Formula
  desc "Command-line tool for working with the Metis Machine platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256 "56e27154e033fab69ad13cedc905e2a7bf1457a79042a848fbd8370177cc9689"

  bottle do
    cellar :any
    sha256 "42b2f57e1968b221f7a7a37b556d61096d7b8c1de0f202d7cd40f1050ab0ca95" => :high_sierra
    sha256 "14c70e41074acfdc0b2e3f111a8af1bb1f9647e004f5a74c8f4d13ca10617c7c" => :sierra
    sha256 "ab7ef279e852d06035df9cf3a533d022c62f9d700acc240bc92168730df1e487" => :el_capitan
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
