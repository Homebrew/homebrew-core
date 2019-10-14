class Shocco < Formula
  desc "Literate documentation tool for shell scripts (a la Docco)"
  homepage "https://rtomayko.github.io/shocco/"
  url "https://github.com/rtomayko/shocco/archive/1.0.tar.gz"
  sha256 "b3454ca818329955043b166a9808847368fd48dbe94c4b819a9f0c02cf57ce2e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "35dec28dfe3249f6675a3334744f985b2a158ee6c484980d90f174f5969a16f8" => :catalina
    sha256 "273f7af2f859f819079d33837c72374cf8c0cddce77bc213295d780dc21e81a0" => :mojave
    sha256 "035ca34f9629648cec2c1bad1acfed26142da87319c773eafc4af0a2d7ced315" => :high_sierra
    sha256 "035ca34f9629648cec2c1bad1acfed26142da87319c773eafc4af0a2d7ced315" => :sierra
  end

  depends_on "markdown"
  depends_on "python"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/source/P/Pygments/Pygments-1.5.tar.gz"
    sha256 "fe183e3886f597e41f8c88d0e53c796cefddc879bfdf45f2915a383060436740"
  end

  # Upstream, but not in a release
  patch :DATA

  def install
    libexec.install resource("pygments").files("pygmentize", "pygments")

    system "./configure",
      "PYGMENTIZE=#{libexec}/pygmentize",
      "MARKDOWN=#{HOMEBREW_PREFIX}/bin/markdown",
      "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
  end

  test do
    system "#{bin}/shocco", "--help"
  end
end

__END__
diff --git a/configure b/configure
index 2262477..bf0af62 100755
--- a/configure
+++ b/configure
@@ -193,7 +193,7 @@ else stdutil xdg-open   XDG_OPEN   xdg-open
 fi

 stdutil ronn       RONN       ronn
-stdutil markdown   MARKDOWN   markdown Markdown.pl
+stdutil markdown   MARKDOWN   markdown Markdown.pl $MARKDOWN
 stdutil perl       PERL       perl
 stdutil pygmentize PYGMENTIZE pygmentize $PYGMENTIZE
