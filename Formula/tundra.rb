class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.11.tar.gz"
  sha256 "004965754e87dcaeb31df757ba3c745b641d1331bbab10e6a96df428bf836c11"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f944a354f01edf79823e2a9f14fc5710b9241f406a1af3e960d986dad456851" => :catalina
    sha256 "2079d743c9a0e55aaef16899c93351236f354799dc9ce07ce7108b2293435faf" => :mojave
    sha256 "cb071edaa1cac9f6176d045ddb87644f10977864539f15b673a59b6c2239c9fe" => :high_sierra
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
