class Wildmidi < Formula
  desc "Simple software midi player"
  homepage "https://www.mindwerks.net/projects/wildmidi/"
  url "https://github.com/Mindwerks/wildmidi/archive/refs/tags/wildmidi-0.4.5.tar.gz"
  sha256 "116c0f31d349eaa74a630ed5a9a17b6a351204877a4ed9fb9aacd9dbd7f6c874"
  license all_of: ["GPL-3.0-only", "LGPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e773a584fef147be9671b30a2f3a390246ecea8cd1a1422c00c21ee5775bfe8"
    sha256 cellar: :any,                 arm64_monterey: "bea15c21531ad36c34f47a59d247a06d5bf1fa0847954ffd709deae333153c5c"
    sha256 cellar: :any,                 arm64_big_sur:  "d3911b6c060df898e6e8e5358a956afaf9bb042083e05be6f7af4f255b80c8bf"
    sha256 cellar: :any,                 ventura:        "26767510ddd3102c627bec0bd407d052a604ddba36c3920deaac00b38e7cdc52"
    sha256 cellar: :any,                 monterey:       "0da132da5f63a79c7f236f7a49ccee626ef53c509344632fbf7a11cb63bf285c"
    sha256 cellar: :any,                 big_sur:        "258eb43be9a818dd975315669930ac09bc3c4da1c349e4dfe3c03685dc2b26e4"
    sha256 cellar: :any,                 catalina:       "ca98c79414e1efd3e398c658aa16ede8af301cb46bafede7a8d1cce56bd45f38"
    sha256 cellar: :any,                 mojave:         "48432227a38bc4252423f60d1eb507057ef7212ae01ee27df2a2882de851d893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d667d4d59f412184ae24c2d7e4acb78bd950435d7dd3dbe613f706525b8a959"
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
