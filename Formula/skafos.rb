class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.3.1.tar.gz"
  sha256 "c5302db83be82497fb850c93f7c578eace23037bd3cc81ae887db32549284fd5"

  bottle do
    cellar :any
    sha256 "b23ebd3db4ccb85cd82ad6e8bc5842da0c418fadb257a34958517b5913204e61" => :high_sierra
    sha256 "aa7071e34230d60ba55e197829205f9ae15c13eea81c75b2937b8577f7f80547" => :sierra
    sha256 "b3eda9fb29a11efafaad16e540efeadbbead13477fb72b9d805a3d91b97e9dc2" => :el_capitan
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
