class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/refs/tags/0.15.7.tar.gz"
  sha256 "d16dbe3b38e3c1dbe3e9a2c5b0a32a801710da2aca66581500ef2b98eba1d8ff"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f849e7e3d6d27d6c42b1bab948d6155863bc01d88b249aadc3c69b1b17277bf"
    sha256 cellar: :any,                 arm64_sequoia: "a9027f49f43e79bc47b7de50b96aeec1bec4a5afe68650065b3e6eb414c3365f"
    sha256 cellar: :any,                 arm64_sonoma:  "9be4cbe0cf4d421607f693006860578348018c8d074543b4d102021ec8c19899"
    sha256 cellar: :any,                 sonoma:        "9f4d0974a2a2443626e74ab1218827defeff80e2d8cae14e3a7e64d7386f20b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d5ce2c575faab8098f0265a1e8fb610ae068445a3d311008e2e9d8e1777da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cd9b83e9f2b799673ebfe3f65c11d5409db0e9af64831d812d3bdcb8374d70"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "bluez"
  end

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
