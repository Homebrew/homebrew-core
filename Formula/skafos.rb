class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.3.tar.gz"
  sha256 "c10474132f58c397b529fd4b566f799fd9e85cdc1b4105fb97acd8787f86785a"

  bottle do
    cellar :any
    sha256 "4f18b50367e5a5abb1fb6000d2c718ffa091cadcda81318291e05fe4351c9ce7" => :mojave
    sha256 "b941a1434209da7ef1686a3372c5ef4639c77492b79e0ebc3d79bb9a3db06ffe" => :high_sierra
    sha256 "a39c7acc90e7621ab54b1449c1233bb27bc445fd3f4b2c01f131b1d9e6805a6d" => :sierra
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
