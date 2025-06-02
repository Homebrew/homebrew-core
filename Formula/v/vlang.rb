class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.4.10.tar.gz"
  sha256 "72541bab3a2f674dcc51f5147fead5a38b18c47a3705335d9c13aa75a0235849"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "61e324a5cb4f1e5fe36e22feece35f101900884c4ee2e184ed2b560861751a6c"
    sha256                               arm64_sonoma:  "a781eaf96128ae65326af2541ff60e35ec8cd28d1ec6fdb2ed22484102af95d0"
    sha256                               arm64_ventura: "14224fb4505f57200c0bd125552913b83fcd1274ca3bfb435fc586036b9d77d3"
    sha256 cellar: :any,                 sonoma:        "ac31a04a8e221306fad1f9fd4e32bdb11f6788d7d6fbf1bdafc994ae4c79be91"
    sha256 cellar: :any,                 ventura:       "9d1829750ac5e28f8820dc46b9f9b025ef7a804613026e0b7848b0c153a89e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9decc51a9efe05ef0c3b4026a191328afb77379ea318bdc3b2115c6738543c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57484b27ff2dde605916de66bb00e53badeec8f683aa49e81f976b0ceccfee1b"
  end

  depends_on "bdw-gc"

  on_linux do
    on_arm do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "compilation failed with errors in vlib/v/ast/scope.v"
      end
    end
  end

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc/archive/66ea39be2275ac723225b9ca99d51ec1212c640d.tar.gz"
    sha256 "c3b57600ad8081a525045d9877e245db834655fefdc79d05dcbed385e0ed0a68"

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
