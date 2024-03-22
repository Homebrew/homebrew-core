class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "82d1cac871a60071e963749228ef8d52954bd0549d0ee2358092b8115fb4915b"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eb56bc906fe0381a1315372fa17bf34103c58db9b0f999a3ff0255b7e858a9a3"
    sha256 cellar: :any,                 arm64_ventura:  "3bd6f31fcb3acfeeda2bd41ca8bd18c93bd927622e603205918aaa8761427fb8"
    sha256 cellar: :any,                 arm64_monterey: "dacc531379694c00fe2c65cef48315446527ecae1f7d03c2472c90358ffd6c94"
    sha256 cellar: :any,                 sonoma:         "63ae752edfdbed0914905a6f75dcd096159c4f51516af8011dda526239e89667"
    sha256 cellar: :any,                 ventura:        "8715e57d34c435dd8d96445cb199b9c2caba7a54d754c5b426a41743263f7cd6"
    sha256 cellar: :any,                 monterey:       "47a256e8668a9a13d29ec595d3bf203cea3645e141742e2127099fec083658fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "495ca0426dba6ab2dcc74f54232438033a70e138468fe852a6fac19460a85b9b"
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
