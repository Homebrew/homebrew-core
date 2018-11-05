class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.08.tar.gz"
  sha256 "b27aa8c13a606559ab757f0409ed8260d3349424923926d3add50f58213d6ca6"

  bottle do
    cellar :any_skip_relocation
    sha256 "731ba1d0b69a0697049f09bf428135743fbbe6aac5422f5983be8bde84550f86" => :mojave
    sha256 "ed4b8f4972973c2c1eb1ba4cc68523bb77fae42b9e05b32d7af8f2ee62c6479a" => :high_sierra
    sha256 "f64f3d3677204d32b25c1819dc3cce4c61bc0a18e66256921862e8d472bc4049" => :sierra
    sha256 "e0c6dd40d2efdcd58bb6976b924b51104e1435f2b93255894d766cca80ff894c" => :el_capitan
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
