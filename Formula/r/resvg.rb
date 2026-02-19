class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "7869119fd822983b0a0bc2469bc94d59e7908fc12165fa67a105a4fa25087f9a"
  license "MPL-2.0"
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f90089fe3e4247ad113c2b84a711dc2dd811e359a6ebfebae1d24c8f80634a6"
    sha256 cellar: :any,                 arm64_sequoia: "aaa0dae4ff75ecfc4d0d2339b0f6a14ac59432b8eafeca39f8724448e0cb2a56"
    sha256 cellar: :any,                 arm64_sonoma:  "111ece6bf433eb6efc157c33b0de64d1819e881d30792219a0564eb400fb41e6"
    sha256 cellar: :any,                 sonoma:        "268d40b77503bb41c303c1a5f4f2b2d5a37030d953b90888191d638333b5b2da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e95a9b431a196ed36a1d2e9e278d71286aab6cf96b67e531283a749b88f0d7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9856e51fa8670f7a16ee58fc8e255e0033278800a42f7ce34672624ba78728a6"
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
