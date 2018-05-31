class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.3.tar.gz"
  sha256 "b5a3e5735f87af11b6140ab0784a2be5339784cd4e2814ca26db878b7f2776b1"

  bottle do
    cellar :any
    sha256 "2cfc9c2641d8a072ff7de8ab88ff0992b2cf67de9e2d60b41eec7325ff3a35fe" => :high_sierra
    sha256 "218661e17b51e41cf86f68031aa50962148dff7141af03f4a60a749e8a914838" => :sierra
    sha256 "83a27c70121c5360f7ab612ba8f95bdc7b6fe81d4d07091cca570f7846930540" => :el_capitan
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
