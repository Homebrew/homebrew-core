class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "a42b8db69bf3d792bb5c46320e9e1eb77155fce257092797996d3663850c7599"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89ac01f3efd842bda12e4099bf31c3eeb7e1d4f599dc4ab44c0ba1c5ce4b2e6c"
    sha256 cellar: :any,                 arm64_monterey: "a508552cb2d6bc65e3a05d3ec3e40e1022e99a1b858eba6c970b768e49b101ac"
    sha256 cellar: :any,                 arm64_big_sur:  "05d352ed05aa3fbbf31c05eae8fb55b7260e41421793a516dc21e3ccc6ce67d3"
    sha256 cellar: :any,                 ventura:        "159a8349ab10e016dc74713c21167cc25c43e2f0a544277e791428b66d24a49b"
    sha256 cellar: :any,                 monterey:       "ce0206df6999f0879319868cfbbc97b94a70c4ab73c7257cbb15640b3c8ac45e"
    sha256 cellar: :any,                 big_sur:        "738e2aa23854ca4f33268b96378f7bf7a2d10a1a619530c9607dda0c7fbb0f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2b349c4b14499b301a4fb6ea8540e733b23013f8cedbc9904340b8bd4bcce3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "crates/c-api/Cargo.toml", "--release"
    include.install "crates/c-api/resvg.h", "crates/c-api/ResvgQt.h"
    lib.install "target/release/#{shared_library("libresvg")}", "target/release/libresvg.a"
  end

  test do
    (testpath/"circle.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    EOS

    system bin/"resvg", testpath/"circle.svg", testpath/"test.png"
    assert_predicate testpath/"test.png", :exist?

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_predicate testpath/"test.svg", :exist?

    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lresvg", "-o", "test"
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end
