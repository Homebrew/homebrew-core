class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  license "BSD-2-Clause"

  stable do
    url "http://www.catb.org/~esr/ski/ski-6.14.tar.gz"
    sha256 "7f81ab281aa6d3ff65a4558a29ad905b1774d28b2c2192b68d8723caf8764933"

    # Fix AttributeError: 'str' object has no attribute 'decode'
    # Issue ref: https://gitlab.com/esr/ski/-/issues/2
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3579d8ff81a16c59efa672da26be95e006c19debd511d532f7fc29011cf02c9"
  end

  head do
    url "https://gitlab.com/esr/ski.git", branch: "master"
    depends_on "xmlto" => :build
  end

  uses_from_macos "python"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "make"
    end
    if OS.mac? && MacOS.version <= :mojave
      rw_info = python_shebang_rewrite_info("/usr/bin/env python")
      rewrite_shebang rw_info, "ski"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end

__END__
diff --git a/ski b/ski
index 2fdbb7e..067fe60 100755
--- a/ski
+++ b/ski
@@ -489,8 +489,8 @@ if __name__ == "__main__":
         if color:
             colordict[ch] = curses.tparm(color, idx)
         else:
-            colordict[ch] = ""
-    reset = (curses.tigetstr("sgr0") or "").decode("ascii")
+            colordict[ch] = b""
+    reset = (curses.tigetstr("sgr0") or b"").decode("ascii")
     terrain_key = colorize(terrain_key)

     print("SKI!  Version %s.  Type ? for help." % version)
