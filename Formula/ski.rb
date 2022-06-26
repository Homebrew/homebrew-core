class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  license "BSD-2-Clause"

  stable do
    url "http://www.catb.org/~esr/ski/ski-6.13.tar.gz"
    sha256 "cfbd251ce2052d24f06db3197d11fa0c0028fc4b5c9bc724653b3dfebed7d028"

    # Fix AttributeError: 'str' object has no attribute 'decode'
    # Issue ref: https://gitlab.com/esr/ski/-/issues/2
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10b4ce4e1bb2f44a779c2f98af93b2ecaec175838aa93191c99b91836d2df8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10b4ce4e1bb2f44a779c2f98af93b2ecaec175838aa93191c99b91836d2df8b3"
    sha256 cellar: :any_skip_relocation, monterey:       "10b4ce4e1bb2f44a779c2f98af93b2ecaec175838aa93191c99b91836d2df8b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "10b4ce4e1bb2f44a779c2f98af93b2ecaec175838aa93191c99b91836d2df8b3"
    sha256 cellar: :any_skip_relocation, catalina:       "10b4ce4e1bb2f44a779c2f98af93b2ecaec175838aa93191c99b91836d2df8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8260309ea5735112878b25d2376f53f3ee5e7a5b36d0eb0f420ded6842406ee"
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
    if MacOS.version <= :mojave
      rw_info = OS.mac? ? python_shebang_rewrite_info("/usr/bin/env python") : detected_python_shebang
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
