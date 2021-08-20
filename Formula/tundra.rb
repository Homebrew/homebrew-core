class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.16.1.tar.gz"
  sha256 "eaf86f183a731c59ad72e3232a1f8b33ca1dc68c39503f99fc9b0cc6e33b50c1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "dbbb68b203aa7c4550f6c16fcf5ad2ad848c2f5620cbbd8218398d69671bc3e7"
    sha256 cellar: :any_skip_relocation, catalina:     "f36ca8b0357c6687cc29a58cca525de2f5f2abbd8d1ec69137cbc5a511745492"
    sha256 cellar: :any_skip_relocation, mojave:       "d89e65ad931ef48f287108e2a06e5b64f34ecb82a00c6b0413833b867c27c764"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e37ea4c934066117b10d4f133c74a5b0527dca0d3509410ddeb3ccb02f3be22a"
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

    os = "macosx"
    cc = "clang"
    on_linux do
      os = "linux"
      cc = "gcc"
    end

    (testpath/"tundra.lua").write <<~EOS
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
            Name = "#{os}-#{cc}",
            DefaultOnHost = "#{os}",
            Tools = { "#{cc}" },
          },
        },
      }
    EOS
    system bin/"tundra2"
    system "./t2-output/#{os}-#{cc}-debug-default/test"
  end
end
