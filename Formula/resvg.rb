class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "5505810ae114c445730de878c214eacad3f3297428f1dade3b3e5c62128dc929"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a65499f44f556958abf8a3578002d3a8cda9e47752b816381df2580ae8d8307"
    sha256 cellar: :any,                 arm64_monterey: "52cf7a3cdeb7e85e1bbc16883a1eb0e880dc1555a01cd6c6070e8c37d9bb7e49"
    sha256 cellar: :any,                 arm64_big_sur:  "dfeeecc39ad08371d5704ec49a2a379963cb245f1c960cb3598af8bf870af3fa"
    sha256 cellar: :any,                 ventura:        "e87c633d584e4ef7daee91fa472e06bc2887aa03e24593dee1fdb085e6f7fbd1"
    sha256 cellar: :any,                 monterey:       "cae621ff8f30f3deb0469906598c8242f81aa44a53a1d5aaae299166f6ece1c1"
    sha256 cellar: :any,                 big_sur:        "eb2653641bef75b2bf0bdea57468467a7669760fe93dfc0d8d8aafefc876aa48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d654b6fe5ab82e9da62e054b72ca7c97d9915e317223da61c116dc0c2fc7457c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "usvg")
    system "cargo", "install", *std_cargo_args

    system "cargo", "build", "--locked", "--lib", "--manifest-path", "c-api/Cargo.toml", "--release"
    include.install "c-api/resvg.h", "c-api/ResvgQt.h"
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
