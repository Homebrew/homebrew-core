class MarkdownRequirement < Requirement
  fatal true
  default_formula "markdown"
  satisfy { which "markdown" }
end

class Shocco < Formula
  desc "Literate documentation tool for shell scripts (a la Docco)"
  homepage "https://rtomayko.github.io/shocco/"
  url "https://github.com/rtomayko/shocco/archive/1.0.tar.gz"
  sha256 "b3454ca818329955043b166a9808847368fd48dbe94c4b819a9f0c02cf57ce2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "de27f8f4ba46c3605130b7ee87b594556afc02aa8b5bf25899a9a71b1e0c8109" => :sierra
    sha256 "2f372c0e3772a787cfcdf9c707eeb1abe7441aa8c63433959a64357ebeec1345" => :el_capitan
    sha256 "8ae351f45044b2bced2b2c3192e007d9127c15ddba472c28a5a4a61214d04663" => :yosemite
    sha256 "b52ada7ff56cf3d34b2c9036f54341ebcc3e713203b53262486cb7ac94bb197b" => :mavericks
  end

  depends_on MarkdownRequirement

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz"
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
    <<-EOS.undent
      You may also want to install browser:
        brew install browser
        shocco `which shocco` | browser
    EOS
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
