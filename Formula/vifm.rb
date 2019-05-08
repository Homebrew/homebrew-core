class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.10/vifm-0.10.tar.bz2"
  sha256 "e05a699f58279f69467d75d8cd3d6c8d2f62806c467fd558eda45ae9590768b8"

  bottle do
    sha256 "ecd4ded0553705dff6ce635bfd424671e9ce8e4c7aebb279fc4040763041e98b" => :mojave
    sha256 "26afd08c530568c64968da378e4913e169fc478d427ebc70f1aba43dc89cc39b" => :high_sierra
    sha256 "ebeea80fbbce5f75d6541c1ee2b1bad9d29076a84ead9b6b9d019b259d7c3566" => :sierra
  end

  # Upstream fix: https://github.com/vifm/vifm/commit/4ad11aca
  # Remove in next version
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end

__END__
diff --git a/src/ui/ui.c b/src/ui/ui.c
index 117ca8b86..ce82b17e8 100644
--- a/src/ui/ui.c
+++ b/src/ui/ui.c
@@ -345,6 +345,11 @@ ui_update_term_state(void)
 int
 ui_char_pressed(wint_t c)
 {
+	if(curr_stats.load_stage < 2)
+	{
+		return 0;
+	}
+
	wint_t pressed = L'\0';
	const int cancellation_state = ui_cancellation_pause();
