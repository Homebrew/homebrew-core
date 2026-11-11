class Resvg < Formula
  desc "SVG rendering tool and library"
  homepage "https://github.com/linebender/resvg"
  url "https://github.com/linebender/resvg/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "ea6629ecaf8ae523aaa42b23217db7fdbed5d4bb070a2574af0d01040195beb1"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/linebender/resvg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a66858b8731c160ccc23ae89febc6b3d8b35ea2aa3630a616f37139b738ebee9"
    sha256 cellar: :any, arm64_tahoe:       "fea6cf22223f2da7658585be191e4130b46cd0a8b136d85db5a8902d4b2a8372"
    sha256 cellar: :any, arm64_sequoia:     "9d373130462cf82e3332e5e278a6df5eb665c290a8f9eccf47e15397bd41aaa1"
    sha256 cellar: :any, arm64_linux:       "fb06974e53150d54155fcec98d41bf67cdf14864160dc61a3e180792d8580b39"
    sha256 cellar: :any, x86_64_linux:      "7693b76d3851be0f05305455630e5eac1a4d690b89af511a6d7d95e2a45324aa"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
