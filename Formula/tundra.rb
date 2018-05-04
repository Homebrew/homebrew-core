class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.07.tar.gz"
  sha256 "dc3cbaf977bdbd0b70e70c455656a6ed69ecd110a5ca9eb938789c044774ddbd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7449f31d23d9cbd91191d25a38384a6bb01c4126c3fbbee7b01659c644d8fc32" => :high_sierra
    sha256 "26cfd885d1bab667f9751adb36e5bf0fba2099dfae101fc6f5ebe4b75cbf8eb3" => :sierra
    sha256 "f6548611e9052ef53ffcaffc4c55e323dadad23d7c7fed56d77fa1100b6b1397" => :el_capitan
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
