class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.4.12.tar.gz"
  sha256 "65e3579df61ae0a7314aa5f0c7eb3b0b9b45170a0275e392e9c168be23046e89"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "66bd18c2171d1bd9d8f25f791690baae240a98837743f21bb50662b266186a34"
    sha256                               arm64_sequoia: "34eebb4e50157633d5e4ab04b216e5857f58248e65b5eda24011685b4d4ff9cb"
    sha256                               arm64_sonoma:  "1fdbf0be4c88696e5302f46434cfc0776c88453e2cbadd31bc8da899e888ee73"
    sha256 cellar: :any,                 sonoma:        "5417d65f37a266f462509fd0934683fc4681fc318ab687b70dc1c60f1769b3e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f826247b5a984b578b0e04c642cda090d10e272be4b0ed06b32cb3e7f397d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b445d348864d8703f9138ec2141a0f3992c2bba7d799fd80cec6379eb92c78e"
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
    url "https://github.com/vlang/vc/archive/e377b42e26eb9c703ccaf65f37d700a7369ac3db.tar.gz"
    sha256 "92714821ca60606751500c3d740de6015b575c078e52fa7c73b0e3346f966de4"

    on_big_sur :or_older do
      patch do
        url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/vlang/vc.patch"
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
