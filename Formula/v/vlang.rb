class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.4.8.tar.gz"
  sha256 "2684d3326a11087746429bd4ad6366d2b696cffc883e3b76fe740a8deb1dc172"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0b3839542ee5796fb2c4a2aaa7f36fb99cf1d110776a258afcced1413b3ad47"
    sha256 cellar: :any,                 arm64_sonoma:  "c8b1b55a3567ef762b8837e91386c45ce57e7c2e7876a718d88574285c4e5c59"
    sha256 cellar: :any,                 arm64_ventura: "f40dcf7b5c9ca6c421cd0489a33706ea46169427d0758778c234a1069cd87d80"
    sha256 cellar: :any,                 sonoma:        "835738f0a1d8b175c10cac76b83fd8380e3e9b87908ef2e93076076b85394c45"
    sha256 cellar: :any,                 ventura:       "1ba59bee75301a9bf360781a9101ae6bd310ef165c973556e7e1922495d92fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b672d9650fea75445704773fd620501bd3ecbd696a1efa295c6a3e2a3f9972f"
  end

  depends_on "bdw-gc"

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "54beb1f416b404a06b894e6883a0e2368d80bc3e"

    on_big_sur :or_older do
      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/4a51a527e534534c3ddc6801c45d3a3a2c8fbd5a/vlang/vc.patch"
        sha256 "0e0a2de7e37c0b22690599c0ee0a1176c2c767ea95d5fade009dd9c1f5cbf85d"
      end
    end
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  patch :DATA

  def install
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix
    # upstream-recommended packaging, https://github.com/vlang/v/blob/master/doc/packaging_v_for_distributions.md
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end
    # `v share` requires X11 on Linux, so don't build it
    mv "cmd/tools/vshare.v", "vshare.v.orig" if OS.linux?

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath/"v1", "v.c", "-lm"
    end
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "cmd/v"
    system "./v2", "-prod", "-d", "dynamic_boehm", "-o", buildpath/"v", "cmd/v"
    rm ["./v1", "./v2"]
    system "./v", "-prod", "-d", "dynamic_boehm", "build-tools"
    mv "vshare.v.orig", "cmd/tools/vshare.v" if OS.linux?

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end

__END__
diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
index 444a014..159e5a1 100644
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -43,13 +43,13 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
+		#flag -I @PREFIX@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
 			$if !use_bundled_libgc ? {
-				#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
+				#flag @PREFIX@/lib/libgc.a
 			}
 		}
 		$if macos {
