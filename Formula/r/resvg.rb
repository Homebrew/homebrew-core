class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "b45c906b4c72ff46405d74eb98ec1b93842f1528a8e835860f22b057b210306a"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28531276a8f61a155cd5d3a13fbb3a4a356b7c097251c204e17145f83693383a"
    sha256 cellar: :any,                 arm64_sonoma:  "7c252685b1357316339380fa2d9b2234decc48e2225b02850ec62f4302c3d22b"
    sha256 cellar: :any,                 arm64_ventura: "07ff4b74fc351966c5175af27bc02559f6dc9b4b24da217799f0c40742d1dc44"
    sha256 cellar: :any,                 sonoma:        "498b1b2d02ff385020bd7d7fe6033b7a79a20903816ef378d1337f7eb1b232ed"
    sha256 cellar: :any,                 ventura:       "e36cea208fde141c0c174d75b2b6e4a7772633c54c48c7a834e54e045b398395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bf96aa1daaab9003c19e0daac5477387f61cc7132dc3069fb855ca92241e3a"
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
