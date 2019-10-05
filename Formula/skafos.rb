class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://skafos.ai/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.7.tar.gz"
  sha256 "42eecd6094126f1e4febf94541c4b640f2b4ed39829af2686cd83a60fafcd994"
  revision 1

  bottle do
    cellar :any
    sha256 "382f356994003f9fa17c2f32bb7851b7f4382589201c9c0ef56f1776180287e4" => :catalina
    sha256 "a9a32e8d9d5b1b0e3ea0e580498fad693a0c5414b28714faee8ef0246d965ced" => :mojave
    sha256 "1f8807243bba9871434cfc69296643602a1830661c2e5f79e3c7a1f4ef52b8a6" => :high_sierra
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
    assert_match "Please enter email", shell_output("expect -f test.exp")
  end
end
