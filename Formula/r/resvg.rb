class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "193cb27744c223579eee5f227549be8c53c3e31270d2c85522987dbf3bec3869"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e48b04c38e2fd150727ce60fb071ec583b7939c595b8464df8f98db64095f46"
    sha256 cellar: :any,                 arm64_ventura:  "42a85e40d88dab404c4aeddc913922d25fa9b4a5c0a23d080faad8944805796b"
    sha256 cellar: :any,                 arm64_monterey: "b4f09d01d80e058757a117eebf90371f1bedab9a14a99f7ca4691b4b7e3394de"
    sha256 cellar: :any,                 sonoma:         "e1f557afa92b5336ab48deda1d8f042432757c526dfdab6219df26f422642186"
    sha256 cellar: :any,                 ventura:        "387637a43befc056a193a8c13709dea501366f9f66b7fa6c0f936868ebf472fc"
    sha256 cellar: :any,                 monterey:       "1b44210571642485831334cab7af83739d8414f7c54bd9fcf710aa934cba2b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957562727722555bc491890fbd4c691ce2b2e7f114d09fc7e8b5a06c87e8aaa0"
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
