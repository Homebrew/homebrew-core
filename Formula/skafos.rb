class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.7.tar.gz"
  sha256 "42eecd6094126f1e4febf94541c4b640f2b4ed39829af2686cd83a60fafcd994"

  bottle do
    cellar :any
    sha256 "33588a039609ca8507dfde7f393057453c0d4489cc474db26084692b8a917bf4" => :mojave
    sha256 "3211215b9502baa2b8e6f068cdb5d7ce9051e5cf03b1ea3ac95aca80c785a076" => :high_sierra
    sha256 "7ecc982c9a65f2b6666d8273b8b9f2e31e707e5b1f308596cef48d8b8ff8e4b2" => :sierra
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
