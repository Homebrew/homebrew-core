class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.3.2.tar.gz"
  sha256 "d597d8eef3389f8e0e20c6157f936d7775878ee4026ab26e7c4130034477dad1"

  bottle do
    cellar :any
    sha256 "c1bc38bbaf0af18b032b1022096c7dd623637d2a28108e6bfbebdc6ff93addda" => :high_sierra
    sha256 "a22831adc56d4b57142c9cb8f61efe73ce3741a6344462f9ec6e5a53779e8daa" => :sierra
    sha256 "5012a1be9748ee0ad837dc1676bcc48f74dd626919aae1ae333f061b0a405c56" => :el_capitan
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
