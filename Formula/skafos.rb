class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://skafos.ai/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.7.tar.gz"
  sha256 "42eecd6094126f1e4febf94541c4b640f2b4ed39829af2686cd83a60fafcd994"
  revision 1

  bottle do
    cellar :any
    sha256 "c11ad9680b5430242f3a945bacb917fdbb1a5f98a422f458240d92db56c5b188" => :mojave
    sha256 "37b0370937fdc69db5edc559e181ff6c076208494bbe733fc5429cb5b975f5a7" => :high_sierra
    sha256 "84ec6534b037c9327939151a3a2e91cc85e8e84eb84ea70df7b4356e8f8f20f9" => :sierra
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
    assert_match "Please enter email", shell_output("expect -f test.exp")
  end
end
