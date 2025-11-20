class Wiiuse < Formula
  desc "Connect Nintendo Wii Remotes"
  homepage "https://github.com/wiiuse/wiiuse"
  url "https://github.com/wiiuse/wiiuse/archive/refs/tags/0.15.6.tar.gz"
  sha256 "a3babe5eb284606090af706b356f1a0476123598f680094b1799670ec1780a44"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "a4bf56429e997f9499a8966ab71e338be19e17918a5ff113bd3dee17ef3a370d"
    sha256 cellar: :any,                 arm64_sequoia:  "d195756409e861db5fe17343c412d3ba38f06723e59854596fc22f44df843ddd"
    sha256 cellar: :any,                 arm64_sonoma:   "064957c4b98791d37e374c115eda18ab973c3fb28121e2c21948249b28101def"
    sha256 cellar: :any,                 arm64_ventura:  "d28f310e6c24c3e2edc8f21831ccedf4a0db4b3460a0efb62ad0824edce82dc0"
    sha256 cellar: :any,                 arm64_monterey: "0f4fb0dc5bb825e093e2122ec79b3bfcc581977139084a76342fd84313e945f6"
    sha256 cellar: :any,                 sonoma:         "e8690ae4966a02202b43a7286d566b38ce4b0cc8f41e9be2741035514606f6fe"
    sha256 cellar: :any,                 ventura:        "76a3830992fa1357910d51d27a55cb0d80380da12d66940260bb33c4580b816a"
    sha256 cellar: :any,                 monterey:       "1456cece746747961b930550f319b1a2985d15afeadb4be526ae4d4b9260614a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3b96eaabc99ef5a85f9a908bc3997acb5a65fc88efc0bfa95b132731f26dbd91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4b00c264565984ad37ebc29999601cc7780303f7015ee7575c21d03e5ba7c5"
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
