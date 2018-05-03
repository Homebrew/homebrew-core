class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.06.tar.gz"
  sha256 "c805882b2a469c46b19c4cf4964b614c840dd914db24066930a83ec61edd24f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b124f44366f4c501397f526b954d77006984fa4b4ecced38753c5fbc559e8aa" => :high_sierra
    sha256 "089bf54b4fb9805b031609270fbec1bb70ad7497bc41aae11025dfd2432b88fe" => :sierra
    sha256 "cebadaa42ebff3a3de3820b4d3de488a6fa9e8a5192c04f106a9a5fae360c252" => :el_capitan
    sha256 "d25e7d649a74cce7ecf9646799e577ba8338c1306f2d2e0692a4fe38f26bc04f" => :yosemite
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
