class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/refs/tags/0.16.0.tar.gz"
  sha256 "084e0afe3ecd392a2daf4392e62e171be7bdf404659c1bfee92e914f973be9a5"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f7cb495f77d3c10593a9ee7047829389808d9fdb8d279f5f70fd5827ef371941"
    sha256 cellar: :any, arm64_tahoe:       "fd5a82ce640c286677832fa788bbe784370c41b13425a619e2480873aa205ac1"
    sha256 cellar: :any, arm64_sequoia:     "b7a924dd8a993b16522c7a871afd957ffa717d9af11ebec54bf17bbd0c2ce046"
    sha256 cellar: :any, arm64_linux:       "8b18075a1a1ec4935b8d2b644b99261d50ad8ae32d9ff4ef4f5eca970c694922"
    sha256 cellar: :any, x86_64_linux:      "263628707d76c8a9c98aed1803fcfca64b9ef111fbd152c62d4d0517e50400e5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "bluez"
  end

  deny_network_access!

  def install
    args = %w[
      -DBUILD_EXAMPLE=NO
      -DBUILD_EXAMPLE_SDL=NO
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <wiiuse.h>
      int main()
      {
        int wiimoteCount = 1;
        wiimote** wiimotes = wiiuse_init(wiimoteCount);
        wiiuse_cleanup(wiimotes, wiimoteCount);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-l", "wiiuse", "-o", "test"
    system "./test"
  end
end
