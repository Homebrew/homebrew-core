class Skafos < Formula
  desc "CLI for the Metis Machine A.I. and machine learning deployment platform"
  homepage "https://metismachine.com/"
  url "https://github.com/MetisMachine/skafos/archive/1.7.6.tar.gz"
  sha256 "c82ffdca0a7317f4f47947ed894a1fd0e54f333e09cebab7158e545aef766b5e"

  bottle do
    cellar :any
    sha256 "7c2aa29f8f539b303000a1e4e1b6a5667d7997e7271eaf903378a1f325c09310" => :mojave
    sha256 "0c54c775a5e98d0473895a2cca259cb74f6dbfc2d39de405b122645b65f0ed25" => :high_sierra
    sha256 "6300fc7cfc58732b68b4fb1e28490bb18a2f0815139928883619750753fdff7b" => :sierra
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
