class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.3.tar.gz"
  sha256 "c10474132f58c397b529fd4b566f799fd9e85cdc1b4105fb97acd8787f86785a"

  bottle do
    cellar :any
    sha256 "157554824b926eca6233c6217fe2ebaf73c5a2dcff30efb9c00798e3cbd99dd6" => :mojave
    sha256 "9978b69abc08daaf5e337bb7d7838ad20d9a8b8c2422e7d219948e88bd1d8d31" => :high_sierra
    sha256 "00c2ccacd3bbb241088c80747fd7807c635f0935ade56e339b864477b9aac0df" => :sierra
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
