class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.13.tar.gz"
  sha256 "22bf9676c958a2d434eb016b1c8cdd5d7af5f4c4b53fd73898064878721a13df"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc64ded68e72f075e17af506b659e1845ed7f44e84353e02551748b7f0ee315" => :catalina
    sha256 "28503f4c9c034763e826103dfb687803ebb68a243d6762975d588fdfd19325b1" => :mojave
    sha256 "a4397eba195c1753ecc9839c367b91c0baf3404361e646f2b78728bcf6eeea0d" => :high_sierra
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
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
