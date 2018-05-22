class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.5.2.tar.gz"
  sha256 "ed8191f7e099e5a51c5adaf8b829e8467de71d9e1de225ba18aa435b2fcb6249"

  bottle do
    cellar :any
    sha256 "4e6b22fe7d90ccad09ca7e3077c8590c85a2048a4eeb8cc23cfa7d90741aeb16" => :high_sierra
    sha256 "e9608844a4112033fc3df478b58d1c6fd807f10f203704f75d872a4854d7e5ca" => :sierra
    sha256 "b3744f0941fc28fcf28d3716aa6c1b2a8206dfb05642303c24c7db27502a2f33" => :el_capitan
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
