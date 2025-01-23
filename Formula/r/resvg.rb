class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "b45c906b4c72ff46405d74eb98ec1b93842f1528a8e835860f22b057b210306a"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "800f2849d0fd12d9eb86ae9c0d419a73dfd51e2b604b0c43b467bdd87969dea0"
    sha256 cellar: :any,                 arm64_sonoma:  "bc4b170d07afd902670101419319e9179fd613bd7b1b0dc701ead93ca7f74747"
    sha256 cellar: :any,                 arm64_ventura: "e1db465f10d7532c8143aeb443835a143e8782b298711b4d2a28d30f3a0e5f28"
    sha256 cellar: :any,                 sonoma:        "378c71885d632bf7f9515faebf9498669167ec8484be7acef543c463363b867f"
    sha256 cellar: :any,                 ventura:       "173495b3638c1913bd176046ed06a7c3e2bff5d9ebaea0e5aabed8f5656858b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6794d803e9bdcbb48cf5c3b0843363e4e606f32fdd0638b6c036aa7561ec5da"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/usvg")
    system "cargo", "install", *std_cargo_args(path: "crates/resvg")

    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--locked",
                    "--manifest-path", "crates/c-api/Cargo.toml",
                    "--prefix", prefix, "--libdir", lib
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

    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs resvg").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_equal "160 35", shell_output("./test #{test_fixtures("test.svg")}").chomp
  end
end
