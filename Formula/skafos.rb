class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.5.tar.gz"
  sha256 "1d234fbd65b8943aa875cc02faf967c2b853cfe05ca98d755efd5bd211339820"

  bottle do
    cellar :any
    sha256 "191268e548112e0a231b75acaeccf47ab28297e0b71d9bcdffa048276b3f104e" => :high_sierra
    sha256 "4a9ff062312288859e564ec5095401ff43549cb7ba252b7dbf7305542554e000" => :sierra
    sha256 "fcdfdf421888ea43e1cbc49d5416142d4dbe3b46b604f4fe25aa519e40002c02" => :el_capitan
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
