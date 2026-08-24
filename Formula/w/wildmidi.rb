class Wildmidi < Formula
  desc "Simple software midi player"
  homepage "https://github.com/Mindwerks/wildmidi"
  url "https://github.com/Mindwerks/wildmidi/archive/refs/tags/wildmidi-0.5.0.tar.gz"
  sha256 "2164396d5fe80153fd2af9764fcd991883d06fbf1fdfd96efbc99eed21ed1a2f"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b9e88989d6462d9f862c9c06fe6f12966de089008278ccf243c08add9f1c6520"
    sha256 cellar: :any, arm64_sequoia: "4959f76d804e6969d248f7456c4817b7825ba9effb1cde9fae7e2fbaa791d4ff"
    sha256 cellar: :any, arm64_sonoma:  "2e775fa17a5cb1590962a64675b8f042c4b9d2c85c0c7d37b97ae13e65229a47"
    sha256 cellar: :any, sonoma:        "a9c47e60a47a8b94b17b43537998a4e30589fa5b950877b327797f52f8782660"
    sha256 cellar: :any, arm64_linux:   "2a4891a8b9a7b031002f597e2f8953560a8b5adac2320718d9bb7d27aa711342"
    sha256 cellar: :any, x86_64_linux:  "cf8b1587c696774e19827bffed3849b6f7ec4044c544a857b57a4bffbdf4955d"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <wildmidi_lib.h>
      #include <stdio.h>
      #include <assert.h>
      int main() {
        long version = WildMidi_GetVersion();
        assert(version != 0);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lWildMidi"
    system "./a.out"
  end
end
