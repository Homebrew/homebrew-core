class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.3.1.tar.gz"
  sha256 "621ff2b4faf214d7023143f6f9d496117c7c75131927837750b904140aff48a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90091569554f168ff5a9cead92ad5dea2841138fdd03604a24e277b68eb54be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4bc638877653809e54c39c56e2279fffdd5677f2bc4c3e4a32d712b072d79e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46fc6c8e4df812c2c796ab93f600f705cf0c74e88f50af9f3901c9980ac6a5a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8e078964013aeab14148c9cbcd6387502d6455a0177d2f89cb831c1f66c7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d5eeeff9f8e1588b4e968cda9eced92211bbbad1ed63b23af80af87c9a9c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4347aa52de2b046a275acb33fe63d8a4647d5234b02f00de89133383541063a"
  end

  # Workaround for https://github.com/Old-Man-Programmer/tree/issues/30
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"tree", prefix
  end
end

__END__
diff --git a/tree.c b/tree.c
index 2d719c4..fa0fba1 100644
--- a/tree.c
+++ b/tree.c
@@ -1564,7 +1564,9 @@ char *fillinfo(char *buf, const struct _info *ent)
   if (flag.g) n += sprintf(buf+n, " %-8.32s", gidtoname(ent->gid));
   if (flag.s) n += psize(buf+n,ent->size);
   if (flag.D) n += sprintf(buf+n, " %s", do_date(flag.c? ent->ctime : ent->mtime));
+  #ifdef __linux__
   if (flag.selinux) n += sprintf(buf+n, " %s", ent->secontext);
+  #endif
 
   if (buf[0] == ' ') {
       buf[0] = '[';
