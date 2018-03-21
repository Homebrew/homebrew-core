class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.3.0.tar.gz"
  sha256 "e7829bcdf0ecf1d2f65b959427f950bec6d44843099c1c84dbac04ca683036f8"

  bottle do
    cellar :any
    sha256 "e2463385b740deee725a4f5b573914070b068855f610d346ced654438654ddbb" => :high_sierra
    sha256 "5520c4e9d8cc99aa056f6b51bf1ee7acdd20b547737e1e176b8799b53b8994b8" => :sierra
    sha256 "eb129c9d41dd67c18c7c44836a62712d5168988354b0a47b490894875c62ae79" => :el_capitan
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
