class Terminator < Formula
  desc "Multiple terminals in one window"
  homepage "https://gnometerminator.blogspot.com/p/introduction.html"
  revision 1
  head "lp:terminator", :using => :bzr

  stable do
    url "https://launchpad.net/terminator/trunk/0.98/+download/terminator-0.98.tar.gz"
    sha256 "0a6d8c9ffe36d67e60968fbf2752c521e5d498ceda42ef171ad3e966c02f26c1"

    # Patch to fix cwd resolve issue for OS X / Darwin
    # See: https://bugs.launchpad.net/terminator/+bug/1261293
    # Should be fixed in next release after 0.98
    patch :DATA
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b2e67f305f175629b8a4673adbfee6da0db29d3d994d68363a458af47f8bd04e" => :high_sierra
    sha256 "b2e67f305f175629b8a4673adbfee6da0db29d3d994d68363a458af47f8bd04e" => :sierra
    sha256 "b2e67f305f175629b8a4673adbfee6da0db29d3d994d68363a458af47f8bd04e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "vte"
  depends_on "pygtk"
  depends_on "pygobject"
  depends_on "pango"

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(prefix)
  end

  def post_install
    system "#{Formula["gtk"].opt_bin}/gtk-update-icon-cache", "-f",
           "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PYTHONPATH", Formula["pygtk"].opt_lib/"python2.7/site-packages/gtk-2.0"
    ENV.prepend_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "#{bin}/terminator", "--version"
  end
end

__END__
diff --git a/terminatorlib/cwd.py b/terminatorlib/cwd.py
index 7b17d84..e3bdbad 100755
--- a/terminatorlib/cwd.py
+++ b/terminatorlib/cwd.py
@@ -49,6 +49,11 @@ def get_pid_cwd():
         func = sunos_get_pid_cwd
     else:
         dbg('Unable to determine a get_pid_cwd for OS: %s' % system)
+        try:
+            import psutil
+            func = generic_cwd
+        except (ImportError):
+            dbg('psutil not found')

     return(func)

@@ -71,4 +76,9 @@ def sunos_get_pid_cwd(pid):
     """Determine the cwd for a given PID on SunOS kernels"""
     return(proc_get_pid_cwd(pid, '/proc/%s/path/cwd'))

+def generic_cwd(pid):
+    """Determine the cwd using psutil which also supports Darwin"""
+    import psutil
+    return psutil.Process(pid).as_dict()['cwd']
+
 # vim: set expandtab ts=4 sw=4:
