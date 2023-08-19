class Wildmidi < Formula
  desc "Simple software midi player"
  homepage "https://www.mindwerks.net/projects/wildmidi/"
  url "https://github.com/Mindwerks/wildmidi/archive/refs/tags/wildmidi-0.4.5.tar.gz"
  sha256 "116c0f31d349eaa74a630ed5a9a17b6a351204877a4ed9fb9aacd9dbd7f6c874"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9f6a91fe4869ffd9a6fdf175455edcb07dc94ede1782e73f87a0f609e19782f"
    sha256 cellar: :any,                 arm64_monterey: "d7f63b942beb87caa17f2a89069cf766c8fe88f9175f0641e01ebd98b270901e"
    sha256 cellar: :any,                 arm64_big_sur:  "eddaba1d79d4686cf0fc6b0cdf6e5b7ce3dc9ab89411c2ff6ace8206f79301ba"
    sha256 cellar: :any,                 ventura:        "3b2063fefbabb8ef456a8052e7c83ed51b0b0fef6ba82a4a11f61d16c698570a"
    sha256 cellar: :any,                 monterey:       "e38845cf8dd6b0714d22854ea133863f0fa651804f3c64f1f0cd7c8c3bcf6b54"
    sha256 cellar: :any,                 big_sur:        "11c6dd85e84f26270f893422a8fa46cf1fffb2ce77902e54c60f199942433bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12e819cf77bb48609994c8daaec9b11c01a4c90cb0fb7464ceee23fa7bfafb86"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
