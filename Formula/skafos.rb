class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.2.tar.gz"
  sha256 "b3a8d4c29f170c0d6342f5db8a9aeaef2e901a5b35bb3e81670878f771c52d40"

  bottle do
    cellar :any
    sha256 "d175157ccabe3d3dccae204f54e1a06d7759bda12bf5002e40ebf8ea9e80cf37" => :mojave
    sha256 "42c027075f50bf6d6d82258844a2c0ae13a1b2e39d2dfd2efa568751d2cdf7bc" => :high_sierra
    sha256 "680dcca8cfea85fd136ce8b0364a14fba9f6e8574416c1ec4ca68268bba9da39" => :sierra
    sha256 "24bf4ec6fc2220216c421274a26c8a5e3d3e676e4e8a7277b58785ff4c7c1b74" => :el_capitan
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
