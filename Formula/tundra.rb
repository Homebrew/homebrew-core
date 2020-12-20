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
    sha256 "039b959316767f2e594f3ba2975f8b9607d526e12549ca7cdbf7bf7256b504d5" => :big_sur
    sha256 "782e5cffac2df8f04a2f86a994a0e6f3dbc5d6c0627119fa2e7e8e9c048b58aa" => :catalina
    sha256 "0fb994652330be64e5375a8a21924c2b6f65505685dfaac7d1dcdf4f26f54016" => :mojave
    sha256 "065e6fc51e912585a278de152b5b149c1d86fc6dd3843d5add5b0a0230c6b118" => :high_sierra
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
