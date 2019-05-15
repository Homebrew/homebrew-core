class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.09.tar.gz"
  sha256 "bda600bd6e2f7f92696402164077099fafff9a91b9f3147e829119122f62b1b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6082037d65042151a6d44e720df2942593714174080c8150af99b91c37d938e" => :mojave
    sha256 "85b08f3a7618ad5fd8b2a79fbf2cedad810c3f7d74b73b09e2e50b38f174f399" => :high_sierra
    sha256 "35a166ef4629ba82ca3156f01f0e2aa34172730f4024076a0b6f6ff86c689374" => :sierra
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
