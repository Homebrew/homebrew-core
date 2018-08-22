class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.6.tar.gz"
  sha256 "ea4ecda18fe3da452275d54dc915ad3f803d089f3649629ab0bef0c87c9634fc"

  bottle do
    cellar :any
    sha256 "c8a5dcbbd6c90a18de5645522bdb2747b6661054324c5e800f5a729aa169ed05" => :mojave
    sha256 "8520b997232e6820dcd57adcca1a0cac519a8454979f84076fdd22092bf018c8" => :high_sierra
    sha256 "170d54256564a9570fc0aa8111bb527e8964ac86db9cfd5e5e89f75e80348d9a" => :sierra
    sha256 "e2125585eac58fa3c15ec16c4fca21543ccc6d94d31b3a0de0e6dbbe36ac3fc6" => :el_capitan
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
