class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "d77997431392ec46f561f547b3788e9b17eddb8a0ae979f033e4eb6384e78bf7"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bfaaaae48157904fa0eb917551ee2da1075c68e5b95def175dddc63435367aa"
    sha256 cellar: :any,                 arm64_ventura:  "aecbd71b976d7ef58912a8071a68ca21d723c324f51ef87992ead4ac130e7d2e"
    sha256 cellar: :any,                 arm64_monterey: "6953e9c016100f42692fb8325e4e4d9dfcb8774e1f8f553912f1a51fc4dc9a48"
    sha256 cellar: :any,                 sonoma:         "73acd01154252767ec8070b7fc0389661d3f08e752b1a8f5e62ec743ed9fe81c"
    sha256 cellar: :any,                 ventura:        "b6c91227ee31f7dd0537119c2f752a027f69cf49bb04fd0c01ba414fbb8e747b"
    sha256 cellar: :any,                 monterey:       "83f0c7fb5b85444886bb0e01fe9884f2e4c8fe0b6cf39e695333ac04b72f3447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be840b9c52e45b8d82ff8a90bc626553c10972ed9f9c532d406805ca1244862c"
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
