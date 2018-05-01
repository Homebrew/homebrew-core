class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.0.tar.gz"
  sha256 "96064f7edb7f7671587a928bd2f7e54d82f5c763e12c8c56dca8d0dff8dd5db8"

  bottle do
    cellar :any
    sha256 "2186e0675f2a123cd193753a62da4b5edd936f94aef17775cb7a391d305ddb69" => :high_sierra
    sha256 "1ccacb5c1fd832b94f9a556815b4fd7fd8b12ad3ad3ee6d6a368de7ce3af3b9c" => :sierra
    sha256 "b79a7c118c358ee181b9032bb967f36d290f7223f0f1c10edd14a846cf3c6ca7" => :el_capitan
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
