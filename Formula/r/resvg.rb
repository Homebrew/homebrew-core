class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "02915519b7409f43110f3cbdc5f87724efd58da1d8516914bdabf060c8a9a178"
  license "MPL-2.0"
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b394b8ad855982ab291e3aca3018d7d41325d9ade7bae391733163655c7bfd36"
    sha256 cellar: :any,                 arm64_sequoia: "034dd22dbb4bf616d68ca85e3b2bdd929f780fcad78ba5b961daba8644f897da"
    sha256 cellar: :any,                 arm64_sonoma:  "08fe0cffbd93de9a3e9a264c3df96614db26d18eb7afc77f14a30a2a6d5779da"
    sha256 cellar: :any,                 arm64_ventura: "cde09970ac7839b75906d8c3e7937eb66cefe1c6d3e931e4632a00bf7877aa21"
    sha256 cellar: :any,                 sonoma:        "3551c00ad4ce2fae49386e1a1fb5a6c63c33ca00c602aa04d9aa988a50a1afb3"
    sha256 cellar: :any,                 ventura:       "544d2b12b296cfc510382c6ed8ff519224c0cb3d9e9ba127023d18c67535bc41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f4bf60e4faa8f86d61d65d2cc7f51589643721cd565b48cee80492cba5150a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b219d496cf0be62b4172762515ccf8039ec43e9864b2d80b641fff9e5a8ea7f9"
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
    assert_path_exists testpath/"test.png"

    system bin/"usvg", testpath/"circle.svg", testpath/"test.svg"
    assert_path_exists testpath/"test.svg"

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
