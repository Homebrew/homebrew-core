class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.15.tar.gz"
  sha256 "c4656a8fb97b0488bda3bfadeb36c3f9d64d9a20095d81f93d59db7d24e34e2b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dbbb68b203aa7c4550f6c16fcf5ad2ad848c2f5620cbbd8218398d69671bc3e7" => :big_sur
    sha256 "f36ca8b0357c6687cc29a58cca525de2f5f2abbd8d1ec69137cbc5a511745492" => :catalina
    sha256 "d89e65ad931ef48f287108e2a06e5b64f34ecb82a00c6b0413833b867c27c764" => :mojave
  end

  depends_on "googletest" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["googletest"].opt_include}/googletest/googletest"

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
