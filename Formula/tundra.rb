class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.01.tar.gz"
  sha256 "abfd932d4e11666044a63f1a88fc9ad9a57d271bcaa4d6d3f54a205f7f73c177"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b124f44366f4c501397f526b954d77006984fa4b4ecced38753c5fbc559e8aa" => :high_sierra
    sha256 "089bf54b4fb9805b031609270fbec1bb70ad7497bc41aae11025dfd2432b88fe" => :sierra
    sha256 "cebadaa42ebff3a3de3820b4d3de488a6fa9e8a5192c04f106a9a5fae360c252" => :el_capitan
    sha256 "d25e7d649a74cce7ecf9646799e577ba8338c1306f2d2e0692a4fe38f26bc04f" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    (testpath/"tundra.lua").write <<~'EOS'
      Build {
        Units = function()
          local test = Program {
            Name = "test",
            Sources = { "test.c" },
          }
          Default(test)
        end,
        Configs = {
          {
            Name = "macosx-clang",
            DefaultOnHost = "macosx",
            Tools = { "clang-osx" },
          },
        },
      }
    EOS
    system bin/"tundra2"
    system "./t2-output/macosx-clang-debug-default/test"
  end
end
