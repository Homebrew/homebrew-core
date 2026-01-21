class SignalwireClientC < Formula
  desc "SignalWire C Client SDK"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "17fa86ba45b4c6363321eac73305153f322342d3f3a101a456f72abeac2ebd89"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab21cc264193c4ddd8d1f0c3a8e7139aba70da83fd668ee6c76b7091d0945a8c"
    sha256 cellar: :any,                 arm64_sequoia: "fe08fc8e14ede77e5bd01ff99911eee6293dbb93a9fea67d9019f18d63b3cf5e"
    sha256 cellar: :any,                 arm64_sonoma:  "ab8f032f759edbafe13460bfc32f629b6cbd1dffb60683ac9f38454c4a8744aa"
    sha256 cellar: :any,                 sonoma:        "256edaf2b0a871c291ede2cb4c87337628f9aff6a23c55ddff2aca52a5bacda5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b669777a936ad84939098f4b0ea6fbd10ff81ac6867404f21818a32562fe47bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6f146d1b53114994c7d769c741098e8a6c08baccfb89b0b873cc4157f493f6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libks"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    # https://github.com/signalwire/signalwire-c/blob/master/examples/client/main.c
    (testpath/"test.c").write <<~C
      #include "signalwire-client-c/client.h"

      int main(void) {
        swclt_init(KS_LOG_LEVEL_DEBUG);
        swclt_shutdown();
        return 0;
      }
    C

    modules = ["signalwire_client#{version.major}", "libks#{Formula["libks"].version.major}"]
    flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", *modules).chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
