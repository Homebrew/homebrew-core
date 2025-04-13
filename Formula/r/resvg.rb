class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/RazrFalcon/resvg"
  url "https://github.com/RazrFalcon/resvg/archive/refs/tags/0.45.0.tar.gz"
  sha256 "871a1583da6af849f8bafd44abc0a75fa7bc9d8ccb242b9e0eae5b5cd4e156c1"
  license "MPL-2.0"
  head "https://github.com/RazrFalcon/resvg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4424c1fdb6ba193b3d1d8936a1bf570fc378b3c0fc540f14cc6177dae02b110b"
    sha256 cellar: :any,                 arm64_sonoma:  "fb45c826007c113259ea5a91d383d754cd8f305bb0c72eb2da0f889c2f8705eb"
    sha256 cellar: :any,                 arm64_ventura: "34ca2202af5af900d1c571c6ee2386201f9ae7d52ced1c8b12c4c678dd690101"
    sha256 cellar: :any,                 sonoma:        "5e0c32ce71b85fab8be04e2ded1b9a79d557dde2869982b59d653ce2c33c0cfe"
    sha256 cellar: :any,                 ventura:       "2c1d0f6f5556afe3dbc9436974dff0530781368aa5d4aa0c43b0fcde4d63e945"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3901ddc65327e922e4320b7dbe4057f9034d63f083076fb218b75bacb5dd1802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b26ecacd503c5bf26523931514a338cab017f8ca23171b5ad1baaaae5ee9d2"
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
