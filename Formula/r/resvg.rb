class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "81a82a8de33da0fcf13fd18532d653bbd0b50b146d82c319dd0ce7294562c7c5"
  license "MPL-2.0"
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eeefb58f87c2e4eaabc68fb25a4983b08d671330f4fab4f4167d28c22525b3e7"
    sha256 cellar: :any,                 arm64_sequoia: "e66c608cee33495f3639b3083083aaa8bb22b3f3f8573bad573488f2af8df652"
    sha256 cellar: :any,                 arm64_sonoma:  "a5e28f71e73c113f16aab3f9895c1eb2fcde4dbb0ea601adfce9cf846a67cf79"
    sha256 cellar: :any,                 sonoma:        "fdb9d9d3d1f988caf540bd3293f71a2da872acfebb2378e94168f7cf252069e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1b0293f6452ee8d17b239ec47d31a0194cc9e1389cec99dc021cbe5beb46d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e532b6cac7b885974e04a7ec1dc52990bfcf0f8b34a3d1d5122b84cb2d6a26"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "crates/c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"circle.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    EOS

    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_path_exists testpath/"test.png"

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_path_exists testpath/"test.svg"

    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <resvg.h>

      int main(int argc, char **argv) {
        resvg_init_log();
        resvg_options *opt = resvg_options_create();
        resvg_options_load_system_fonts(opt);

        resvg_render_tree *tree;
        int err = resvg_parse_tree_from_file(argv[1], opt, &tree);
        resvg_options_destroy(opt);
        if (err != RESVG_OK) {
            printf("Error id: %i\\n", err);
            abort();
        }

        resvg_size size = resvg_get_image_size(tree);
        int width = (int)size.width;
        int height = (int)size.height;

        printf("%d %d\\n", width, height);
        resvg_tree_destroy(tree);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs resvg").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end
