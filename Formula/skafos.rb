class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://skafos.ai/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.7.tar.gz"
  sha256 "42eecd6094126f1e4febf94541c4b640f2b4ed39829af2686cd83a60fafcd994"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, catalina:    "2f1a06251a8e92a986afbefbfc380dd50c237bf0a59546ebcb89ee4f31b73e3a"
    sha256 cellar: :any, mojave:      "c487b351e95ab98ef03e4184020bda27b1cdc8353cfb505a54e75036731cfe0e"
    sha256 cellar: :any, high_sierra: "57dc00bd0e8bfc96998c690cbd77a7c4c6486d50655603bfdf65771e340ee6b6"
  end

  disable! date: "2022-07-31", because: :repo_archived

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
