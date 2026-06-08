class TreeSitter < Formula
  desc "Incremental parsing library"
  homepage "https://tree-sitter.github.io/"
  url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.9.tar.gz"
  sha256 "8e14780500933f43d86662fcaa1b0ce99ebe9c220f4680bc929dce09a0e0cfc6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/tree-sitter/tree-sitter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1877f8dfe17f3b673ee80260afa5e2e02c4d7a966cff1e938982ebe5eb7adcd0"
    sha256 cellar: :any,                 arm64_sequoia: "14c6c001055fb88669ff6f9dbe50d0c749ea7918b7aa5dd7e96b8043de9ee54d"
    sha256 cellar: :any,                 arm64_sonoma:  "08e49eaf87b519b66617d46e7fca951c22a03d6cdc063c80063da3d3995e3ebf"
    sha256 cellar: :any,                 sonoma:        "38ff8be56b6a5c39875a93e57350e51522d6ce6e2a78baea8ebdadc65650a0f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f1218072c309f8ec39f864a8da47e3040e38e3044ccf2656f4ad0a05820ea41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd344be8e97233097f338472b95c9c0b81b925e988ce3633ba36e7cb8b880fb2"
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
