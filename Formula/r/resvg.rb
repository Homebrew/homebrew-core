class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "263293020fc6cfadf6c4b6dc738f97ae33d3de8e47452fc6487c43392508a905"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "338e4eb152bfb5399956a835a46bf6b80c3e058f78c2647a87e58fcbad354c7a"
    sha256 cellar: :any,                 arm64_ventura:  "d4767d76090d1ecc34d8156c1cb0658da29f7d73d6cc4d119bc3336fc198d343"
    sha256 cellar: :any,                 arm64_monterey: "5e9d70304126bf687b8693f74b1f9984a395b24cfeda7b755cc4923ad8065d4b"
    sha256 cellar: :any,                 sonoma:         "3a46c91d0cbb4a42b5f39109a19de190cd3926d70c979223b355dcc1af2f9969"
    sha256 cellar: :any,                 ventura:        "58cc526920d8a0460433d8b773282ae91dc903dddfcc126b5d46ae401d407c19"
    sha256 cellar: :any,                 monterey:       "6dda5173c566a0310bd1b9135dbb5eae2d8bf262eadfa0f5dedd8d7490fb2abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763f534ae335453577fd14903846bd5eb1fa44c8b3f06b8994b0c73f17ef8aa4"
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
