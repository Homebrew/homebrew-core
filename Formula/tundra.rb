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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f813f11bfda97c4e172e926c01a1104097f6bd61d344cf01031cf359e422d5da"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e7970c3893238a41438bcc2dfb96f24b826ccf93a2c1c75dfdec4ab5a39186c"
    sha256 cellar: :any_skip_relocation, catalina:      "72abfc5263693f27df124037c5b40764bbce51bf7922316d1f2dcdc5fbe5f2d1"
    sha256 cellar: :any_skip_relocation, mojave:        "ea38828937d82358d09da4c756b31bf6ee7c5884b40a750900e2b45566946c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1d1d7343ad50600eb93665e46db9da7c0fb6e64240eed31b9078b249a42aab"
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
