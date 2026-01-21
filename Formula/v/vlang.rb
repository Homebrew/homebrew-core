class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.5.tar.gz"
  sha256 "53474b6920aba3bb13a12f6ca430581b3b9b90d2e1432c7afd90da45f1566aaa"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "498e8cb0275d01f1486f98c470be304050789b0cd7432a38a28dd47233e8fe01"
    sha256                               arm64_sequoia: "f5c47a6fd274882aacb32eaa88a06584d46a6d0ccf926b44622db0612552696a"
    sha256                               arm64_sonoma:  "ed8c96275ec38c3d56e229f6cdfef3c3a5298577bf3c273022d9e68947667ca8"
    sha256 cellar: :any,                 sonoma:        "e29f74308e99f9d05917ca7a9ee45699f8bc45d9663215c79b1082080eab35f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "624e8bbb90f61307a8590b50453f75954888823bac0991d641057b3c94d9d456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25580978c612f524dabefcc113b941e89a09ad00cea0b24beb1336b6a5f61b6f"
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
    # The vc repo (https://github.com/vlang/vc) contains bootstrapping compiler sources.
    # When updating vlang, find the vc commit whose message matches this release:
    #   [v:master] <vlang commit SHA> - V <version>
    # Then use that vc commit's SHA in the URL below.
    url "https://github.com/vlang/vc/archive/294bff4ef87427743d0b35c0f7eb1b34a6dd061b.tar.gz"
    sha256 "bc5ba06d186b5ae33de9fe8176d3bc6e39543c4454a6b2bd4392c73785dfada8"

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
