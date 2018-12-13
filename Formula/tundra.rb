class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.08.tar.gz"
  sha256 "b27aa8c13a606559ab757f0409ed8260d3349424923926d3add50f58213d6ca6"

  bottle do
    cellar :any_skip_relocation
    sha256 "452cf94a919ac957eccbd47347bc94da67653acb5ec2020a7767fd50f6d9589e" => :mojave
    sha256 "b9c54d89a948a457ad5cf5e70366c43f2efef5a43aa11fc136b6e6b0800039c5" => :high_sierra
    sha256 "5a49d13377f30d7822376ac9668441139b5512172d00d71a2a62baf772bcdffb" => :sierra
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
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
