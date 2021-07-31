class Wildmidi < Formula
  desc "Simple software midi player"
  homepage "https://www.mindwerks.net/projects/wildmidi/"
  url "https://github.com/Mindwerks/wildmidi/archive/refs/tags/wildmidi-0.4.4.tar.gz"
  sha256 "6f267c8d331e9859906837e2c197093fddec31829d2ebf7b958cf6b7ae935430"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + %w[
      -S .
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <wildmidi_lib.h>
      #include <stdio.h>
      #include <assert.h>
      int main() {
        long version = WildMidi_GetVersion();
        assert(version != 0);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lWildMidi"
    system "./a.out"
  end
end
