class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "8f84ba56c66f1f247b154bd9618ea33ffc628a09b7b1a95abb37b0e4187d2419"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08f3221692e99871cc47569e75be49f796f8c9f6adb8d0f2eba2664b12b89895"
    sha256 cellar: :any,                 arm64_monterey: "2f1125e9bb399f46431cf29e8ca8c573c3e969c9e99275b048b0b96faec0e753"
    sha256 cellar: :any,                 arm64_big_sur:  "ca8926cb9b55e47e19c0d3ef02b22dd827f0a88531a24f6e38a86c0562c79f9f"
    sha256 cellar: :any,                 ventura:        "e7c140e29c8b5d4ff5dec4ba055f5f3ddacff8b03f96d3fff517fc8cd79c168f"
    sha256 cellar: :any,                 monterey:       "303a71a0df3ca4c33dad27e58e4ad60f21ce42b09e130805e3114d723f178056"
    sha256 cellar: :any,                 big_sur:        "9685826d6663177dd2e08fb619ac4a0a72b907785f891206756f52ce95cc22ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898566ef7a7ccbe1f12b1d0acc4592b735899fdba96ddae8525f4c432e1ef750"
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
