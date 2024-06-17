class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "277ae58105d96e6ed6b22df75fab4eb93c3802623d675b9f4970a64e00c2a1e4"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf44f3fc02ff87b16d6dd8dc7ae276796f1ec83bd589056489071ff670348f57"
    sha256 cellar: :any,                 arm64_ventura:  "f82981fa19fac89e95ee41bba260e5c237560aa5b79d118217f7ac77409775cb"
    sha256 cellar: :any,                 arm64_monterey: "ca62969f0b58e5557a4995c3d333d351990e09fb2a826e34c008b2ca0439eb8a"
    sha256 cellar: :any,                 sonoma:         "d91c308787f442a6cd9176e8705695f245499745345fa7c72dbe77dcac54121a"
    sha256 cellar: :any,                 ventura:        "9031d0283f0a3ecb001435eb98c7760cc7c68e274f9b0d9525b2f95be95e054a"
    sha256 cellar: :any,                 monterey:       "c2b3cd4057b250fc4ec3bbf25e0f259fc203b44eb3bb2b44cce1310e9e677161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "719dd2267b5b9ad5955cd8d626bda5f93ac19747aece72e3538ceec3ef7c58d8"
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
