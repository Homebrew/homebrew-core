class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "489e767d4e87f18336ead22a99e64f338cd980a948bf875cfa60742eff7170cc"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7abdf612f19f6244762793e80d959dee22ec07eb556670a31e6a57c284a17d50"
    sha256 cellar: :any,                 arm64_ventura:  "b217dc742c13f9f56e707d1480c35b837a93501a123a8ad8f4968f9c983ee472"
    sha256 cellar: :any,                 arm64_monterey: "131e574be87c7805d22ef610817561aea8ea740c7ae05e7286f27e1fc5955c28"
    sha256 cellar: :any,                 sonoma:         "7db0805d910cab654c286b11c01bab8e78d209c1a3747761c413224bd3f9b4bb"
    sha256 cellar: :any,                 ventura:        "ab1d3c3b16d578593ea27c874fd5aa50e471403cacfee811ce561d959d4e46e4"
    sha256 cellar: :any,                 monterey:       "4c17705989b94417e021d335e24e5c7a60a23e08cae300650abd7779a076aadb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b840cb6b2db175b56e1949f3c5e5d69f43be7add4a952d4369af54bb4634b732"
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
