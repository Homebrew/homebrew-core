class Tenyr < Formula
  desc "32-bit computing environment"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.6.0.tar.gz"
  sha256 "fc9ed9f6f46c79470163ed5e9f2f820aab74c7bd972315862d3cca547988684c"

  head "https://github.com/kulp/tenyr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ffa29217b05ea8f74719b43369b483f0ad20ba1534b80b430e22f585b1dbc44" => :sierra
    sha256 "21f73763ac69ceca9e98ac6c8bc471772b6337ecc18acf13faabdaaabd01e25a" => :el_capitan
    sha256 "180229f9b3855dcb64225c1e5b1ea22105f3931146d2b818d61a5f9058f5fbb7" => :yosemite
    sha256 "c20b4f63feb6150edc2e46222eed8329d0e8e5bb8bdfa3f84a87059ed03d95a4" => :mavericks
  end

  depends_on "bison" => :build # tenyr requires bison >= 2.5
  depends_on "sdl2"
  depends_on "sdl2_image"

  patch :DATA

  def install
    bison = Formula["bison"].bin/"bison"

    inreplace "Makefile", "bison", bison

    system "make"
    bin.install "tsim", "tas", "tld"
  end
end

__END__
diff --git a/src/debugger_parser.y b/src/debugger_parser.y
index c000640..289e4da 100644
--- a/src/debugger_parser.y
+++ b/src/debugger_parser.y
@@ -13,6 +13,7 @@
 int tdbg_error(YYLTYPE *locp, struct debugger_data *dd, const char *s);

 #define YYLEX_PARAM (dd->scanner)
+void *yyscanner;

 %}

diff --git a/src/parser.y b/src/parser.y
index 6eb4dd1..e3f23df 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -40,6 +40,7 @@ static int check_immediate_size(struct parse_data *pd, YYLTYPE *locp, uint32_t
         imm);

 #define YYLEX_PARAM (pd->scanner)
+void *yyscanner;

 struct symbol *symbol_find(struct symbol_list *list, const char *name);
