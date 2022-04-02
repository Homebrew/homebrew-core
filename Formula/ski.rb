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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80da0faf28f34d0440e89fa1761ad91e46be161925f42d6f3cfe6e2f74e718a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6032ccdfd57a414c4c7336aee66c03416b549ffba4aa9de2e5f456e7666b27ae"
    sha256 cellar: :any_skip_relocation, catalina:      "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253"
    sha256 cellar: :any_skip_relocation, mojave:        "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253"
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
