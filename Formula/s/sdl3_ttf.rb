class Sdl3Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-3.2.2/SDL3_ttf-3.2.2.tar.gz"
  sha256 "63547d58d0185c833213885b635a2c0548201cc8f301e6587c0be1a67e1e045d"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec74409d1b465395c8729c489d256b309154222a3e68d371077038fccb19d793"
    sha256 cellar: :any,                 arm64_sequoia: "472dbc6423662615b135349d3a51e7e71f8bcc143b8ce53e8cfff168680bdebe"
    sha256 cellar: :any,                 arm64_sonoma:  "761daa6864eee45de9e75ead2633c10a5087ab441b16c41b1fcf5feb7678442d"
    sha256 cellar: :any,                 arm64_ventura: "202985317ea2e7476b167c5eca26fed1c0558ebe2ef224b83baa43660c725400"
    sha256 cellar: :any,                 sonoma:        "20d9df460677a3f2dd6c8d64597b67f490bfff11d3adc9aa371d84ab30c4557b"
    sha256 cellar: :any,                 ventura:       "8bdf3baad110c9378c3300dc5ca527dd8bb749bddb43176a28a657eb7ce51825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea76401d8c8edf3b8ca544b28566e68b6a168d42f6a313129ada522d1b0c2f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b74cf99210527d2a98f1a1c3321f9c933ca969df0b01667630deebbde43183"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    system "cmake", "-S", ".",
                    "-B", "build",
                    "-DSDLTTF_PLUTOSVG=OFF",
                    "-DSDLTTF_INSTALL_MAN=ON",
                    "-DSDLTTF_STRICT=ON",
                    "-DSDLTFF_VENDORED=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_ttf/SDL_ttf.h>
      #include <stdlib.h>

      int main() {
        return TTF_Version() == SDL_TTF_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_ttf", "-o", "test"
    system "./test"
  end
end
