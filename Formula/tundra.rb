class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.01.tar.gz"
  sha256 "abfd932d4e11666044a63f1a88fc9ad9a57d271bcaa4d6d3f54a205f7f73c177"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bbd62530aa1dfac344a9a4d880eb9725ff20bf97e149e5f152ecbc583e41278" => :sierra
    sha256 "51e111d89555e8eb2229eb9eb73b085a45c45fbddc10d0f6c179b199a907e19a" => :el_capitan
    sha256 "b676cf79e11819ad9beebeae6cde5cad31cc7730e4c8dcafbacdbbd9e0affba7" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-'EOS_SRC'.undent
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS_SRC
    (testpath/"tundra.lua").write <<-'EOS_CONFIG'.undent
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
    EOS_CONFIG
    system bin/"tundra2"
    system "./t2-output/macosx-clang-debug-default/test"
  end
end
