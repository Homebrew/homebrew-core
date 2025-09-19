class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "024a2478579acebbb8882d7c2c0f0e07fc0aa19a459b48d10469e4abb96cf16e"
  license "MIT"
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "389d617478b08d0219b4d815a12b1002661c5aec7a4c07921470aacf5046312f"
    sha256 cellar: :any,                 arm64_sequoia: "50db20e018958001f434cc4b7218e7f716477e14a5a015b37a3773aef2d7b44c"
    sha256 cellar: :any,                 arm64_sonoma:  "38b306b00ec376d14f562765a342dd300b1309a2165ab80e40f2e2e140bcda5f"
    sha256 cellar: :any,                 arm64_ventura: "190dda465da4c905e3c2b5d25b93c931d701c75529967fe36c92f990337bdfbb"
    sha256 cellar: :any,                 sonoma:        "f34a1158199031344dab597eab566753a0a6a9b6524cb936fc73396fe62f151a"
    sha256 cellar: :any,                 ventura:       "50ba83fdd0743e7a3544312e464b3462ca065dd3695d279fab6323cc59783fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b11e6e1bea0c662773edf84614225aa61d872e6809133ba8e3326bd59e5d394a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1a110b852b1623187b2234b485607e94519f48c1bd83c6d6734158f3f9200f"
  end

  def install
    system "make", "install", "AMALGAMATED=1", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      This formula now installs only the `tree-sitter` library (`libtree-sitter`).
      To install the CLI tool:
        brew install tree-sitter-cli
    EOS
  end

  test do
    (testpath/"test_program.c").write <<~C
      #include <stdio.h>
      #include <string.h>
      #include <tree_sitter/api.h>
      int main(int argc, char* argv[]) {
        TSParser *parser = ts_parser_new();
        if (parser == NULL) {
          return 1;
        }
        // Because we have no language libraries installed, we cannot
        // actually parse a string successfully. But, we can verify
        // that it can at least be attempted.
        const char *source_code = "empty";
        TSTree *tree = ts_parser_parse_string(
          parser,
          NULL,
          source_code,
          strlen(source_code)
        );
        if (tree == NULL) {
          printf("tree creation failed");
        }
        ts_tree_delete(tree);
        ts_parser_delete(parser);
        return 0;
      }
    C
    system ENV.cc, "test_program.c", "-L#{lib}", "-ltree-sitter", "-o", "test_program"
    assert_equal "tree creation failed", shell_output("./test_program")
  end
end
