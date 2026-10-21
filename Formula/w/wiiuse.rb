class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/refs/tags/0.16.0.tar.gz"
  sha256 "084e0afe3ecd392a2daf4392e62e171be7bdf404659c1bfee92e914f973be9a5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "202c73205053c5693bf53258f36136a3aa513b41f98922a416da2ae96d53fa37"
    sha256 cellar: :any, arm64_tahoe:       "c3799c163d4e1ac54f1dcadacdbd4efe6be1b17ea241c8a26ce9d04e16c3045d"
    sha256 cellar: :any, arm64_sequoia:     "96402711a377e57842d8d00d97031162828270e23c61d50604cba4d3efc13b36"
    sha256 cellar: :any, arm64_linux:       "45e1cac29dd121e10b42b68919a2bbd97593f2138267e4904f71d8a427726243"
    sha256 cellar: :any, x86_64_linux:      "69110bbdc0be45011b7957145783023cdd56bf8406f38fd0b2bc232c75014c99"
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
