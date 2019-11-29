class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/0.15.5.tar.gz"
  sha256 "d22b66eb13b92513c7736cc5e867fed40b25a0e398a70aa059711fc4f4769363"

  bottle do
    cellar :any
    sha256 "5464a5da078f37d0444521d04b95092aeec982cf41949328c8bfd4c5aea791a9" => :catalina
    sha256 "81f9c831744a302586fa3158fe29127aaeeac73e0d5c074425abda85ecf2f00c" => :mojave
    sha256 "1a6064dd68d05c22b3078371569eec25311ff222f795c2eb2dc71848089b3230" => :high_sierra
    sha256 "c14e2c7d0a576284818879a756b0da9dd0bf4d9c789d301b69afe3a0f7c9bc17" => :sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DBUILD_EXAMPLE=NO
      -DBUILD_EXAMPLE_SDL=NO
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <wiiuse.h>
      int main()
      {
        int wiimoteCount = 1;
        wiimote** wiimotes = wiiuse_init(wiimoteCount);
        wiiuse_cleanup(wiimotes, wiimoteCount);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-l", "wiiuse", "-o", "test"
    system "./test"
  end
end
