class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.0.tar.gz"
  sha256 "56e27154e033fab69ad13cedc905e2a7bf1457a79042a848fbd8370177cc9689"
  revision 1

  bottle do
    cellar :any
    sha256 "d75ae93e2fe34bf518bda8ebb1ca5915272e58b459b5d724858234f029bf6499" => :high_sierra
    sha256 "c5aab495b1202b37d5514e3772fcc49acbc19def8fe266010a4adc9cb2cf200b" => :sierra
    sha256 "8a2a5fc09c989a677f8cd5463b12fd58bc1e9dc4c30456d42126afbbd24891a2" => :el_capitan
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
