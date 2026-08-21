class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "40dafea6b4b9d01e9d28b6d49f1e912daf3e9055676ad9179a5a2db6e7386945"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "449716d5a7f828b57202b65c37fb27d946bc77a2ab416a41e6fc3520c962a7e3"
    sha256 cellar: :any, arm64_sequoia: "58c2ab3142ad4b2a3000c06c2f660579deb4b39a3bcf5a310a27d71d8623ca9b"
    sha256 cellar: :any, arm64_sonoma:  "208e78e1f8c07a4f6772a9865ef1adcfdd39e867b5cd6974a96be57606d6ab21"
    sha256 cellar: :any, sonoma:        "7c76b84eea40473a25dfa1402103736f2b180c95b379b0509c3fb8cff6981772"
    sha256 cellar: :any, arm64_linux:   "dcf43aaa57996d454fb087c660a18515b90b122c49b43071d463232df975fb02"
    sha256 cellar: :any, x86_64_linux:  "7b9945b64cabc2a23d70a6bf65f3b1c3a71adb79c6f988c4a841aad9d6f6fcae"
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
    (testpath/"circle.svg").write <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" height="100" width="100" version="1.1">
        <circle cx="50" cy="50" r="40" />
      </svg>
    SVG

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
