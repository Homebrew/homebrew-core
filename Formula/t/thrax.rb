class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.9.tar.gz"
  sha256 "1e6ed84a747d337c28f2064348563121a439438f5cc0c4de4b587ddf779f1ae3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1eb8c3d01b8131ea4cc7040397c4eb266c02d517d9076722f322075c93521674"
    sha256 cellar: :any,                 arm64_sonoma:  "b3bfcb2f229d5709774df18f6bd4d4915a03218b430bc4cae498cfc98b387569"
    sha256 cellar: :any,                 arm64_ventura: "87aea2fcc77a37ff7eb3118757a6e224c8e4704a26cae719a8a123bac9b8a3bb"
    sha256 cellar: :any,                 sonoma:        "63a97b5dfbe107ab19a9780f7fd346e421af9ecadc30a0faca9110707cafacec"
    sha256 cellar: :any,                 ventura:       "ea2651cc17ba7837e2e6f362124c9f6c9d06034521dfd86468d4e13220fc9893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7eb89d693322a62b6409eaf8d21a502d307401726f5f8563695944350ab92d"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openfst"
  uses_from_macos "python", since: :catalina

  # patch to build with openfst 1.8.4, notified upstream about this patch
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"thraxmakedep"
  end

  test do
    # see https://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system bin/"thraxmakedep", "example.grm"
      system "make"
      system bin/"thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end

__END__
diff --git a/src/include/thrax/algo/stringmap.h b/src/include/thrax/algo/stringmap.h
index f2ea7a7..6ee0a7c 100644
--- a/src/include/thrax/algo/stringmap.h
+++ b/src/include/thrax/algo/stringmap.h
@@ -180,7 +180,7 @@ bool StringMapCompile(internal::ColumnStringFile *csf, MutableFst<Arc> *fst,
     const auto log_line_compilation_error = [&csf, &line]() {
       LOG(ERROR) << "StringFileCompile: Ill-formed line " << csf->LineNumber()
                  << " in file " << csf->Filename() << ": `"
-                 << ::fst::StringJoin(line, "\t") << "`";
+                 << ::fst::StrJoin(line, "\t") << "`";
     };
     switch (line.size()) {
       case 1: {
@@ -225,7 +225,7 @@ bool StringMapCompile(const std::vector<std::vector<std::string>> &lines,
   for (const auto &line : lines) {
     const auto log_line_compilation_error = [&line]() {
       LOG(ERROR) << "StringMapCompile: Ill-formed line: `"
-                 << ::fst::StringJoin(line, "\t") << "`";
+                 << ::fst::StrJoin(line, "\t") << "`";
     };
     switch (line.size()) {
       case 1: {
