class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.5.tar.gz"
  sha256 "1d234fbd65b8943aa875cc02faf967c2b853cfe05ca98d755efd5bd211339820"

  bottle do
    cellar :any
    sha256 "ea4f8deb1996bafe91d870e41d2c5d14ecf65514ef9a2cf893f1eef2d0f5a9bb" => :high_sierra
    sha256 "37b76a28b92e191c73fac0c37b892cff2192c7fca0c194ab9e8d4152d1a64a1e" => :sierra
    sha256 "fadcabf35267e761ee4c8eabdb94a278a40fb2a7695f81480c6111ad5043c0ef" => :el_capitan
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
