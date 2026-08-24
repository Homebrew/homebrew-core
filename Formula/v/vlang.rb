class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.5.2.tar.gz"
  sha256 "1a05f646fba9516ec6307979b282d0cc5327075bef268d40c0ca7d0b887e4f52"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "bfcca56799ff42156cbde905da0fb8ddfadd7613d0cd05e147cbb2201af13bc0"
    sha256               arm64_sequoia: "bce1478d41c56d1977683a5155e1a1575b2b329c9cc8cc6827420f426209d1fd"
    sha256               arm64_sonoma:  "bce8019e452f8c4cbc92ba4ce84cad16be09ab17cef8379022086c648cadf973"
    sha256 cellar: :any, sonoma:        "fd6ed7cdab28ef1ecd7236e96cee1c009b952254e4fbb5dfea961c40208ee883"
    sha256 cellar: :any, arm64_linux:   "9d967dd4448c15167b9d3266c34a4d8a7777499e3c190bebf117a2eed9ba0689"
    sha256 cellar: :any, x86_64_linux:  "74c220fb73ed5a2290eb7e600a742a35e1abdc77452f5c44f794f2afb3cee506"
  end

  depends_on "bdw-gc"
  # `v sqlite` and the new-in-0.5.2 `v bug` tool import `db.sqlite`, whose C
  # header is gated on `$pkgconfig('sqlite3')`. Provide sqlite3.pc so it builds.
  uses_from_macos "sqlite"

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # The vc repo (https://github.com/vlang/vc) contains bootstrapping compiler sources.
    # When updating vlang, find the vc commit whose message matches this release:
    #   [v:master] <vlang commit SHA> - V <version>
    # Then use that vc commit's SHA in the URL below.
    url "https://github.com/vlang/vc/archive/7eb8c54a3843e5107d5af06d7a8c3e928f322475.tar.gz"
    sha256 "255d5e999edf71dd2786c06a0fdcda47ecfd79d9fde3c9cf7548e36996284f45"

    on_big_sur :or_older do
      patch do
        file "Patches/vlang/vc.patch"
        type :unofficial
      end
    end
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  patch :DATA

  def install
    # V's bundled pkg-config reads PKG_CONFIG_PATH but not PKG_CONFIG_LIBDIR, where sqlite3.pc is.
    ENV.append_path "PKG_CONFIG_PATH", ENV["PKG_CONFIG_LIBDIR"]

    # upstream-recommended packaging, https://github.com/vlang/v/blob/master/doc/packaging_v_for_distributions.md
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end

    # `v share` requires X11 on Linux, so don't build it. `v bug`'s generated C
    # also fails to compile on Linux in 0.5.2 (a `#undef L_tmpnam` collision
    # breaks glibc's <stdio.h>), so skip that tool on Linux too.
    # Upstream issue: https://github.com/vlang/v/issues/28108
    if OS.linux?
      mv "cmd/tools/vshare.v", "vshare.v.orig"
      mv "cmd/tools/vbug-report.v", "vbug-report.v.orig"
    end

    resource("vc").stage do
      system ENV.cc, "-std=c99", "-w", "-o", buildpath/"v1", "v.c", "-lm", "-lpthread"
    end

    bootvfflag = OS.linux? ? ["-cc", ENV.cc] : []
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "-prod", *bootvfflag, "cmd/v"
    system "./v2", "-nocache", "-o", buildpath/"v", "-prod", "-d", "dynamic_boehm", *bootvfflag, "cmd/v"
    rm ["./v1", "./v2"]
    # `v -prod build-tools` regressed in 0.5.2: building some tools with `-prod`
    # (LTO) exhausts memory and crashes the build. Build the tools without
    # `-prod`; the `v` binary itself is still built with `-prod` above.
    # Upstream issue: https://github.com/vlang/v/issues/28108
    system "./v", "-d", "dynamic_boehm", *bootvfflag, "build-tools"
    if OS.linux?
      mv "vshare.v.orig", "cmd/tools/vshare.v"
      mv "vbug-report.v.orig", "cmd/tools/vbug-report.v"
    end

    (buildpath/"cmd/tools/.disable_autorecompilation").write ""

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"

    generate_completions_from_executable(bin/"v", "complete", "setup", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    require "utils/linkage"

    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
    assert !Utils.binary_linked_to_library?("test", formula_opt_lib("bdw-gc")/shared_library("libgc")),
            "v should not produce binary dynamically linked to bdw-gc! Check the patch in the formula!"
  end
end

__END__
diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -65,44 +65,14 @@
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
+		#flag -I @@HOMEBREW_PREFIX@@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag -DALL_INTERIOR_POINTERS=1
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
 			$if !use_bundled_libgc ? {
-				$if macos {
-					$if tinyc {
-						$if arm64 {
-							// tcc on macOS arm64 can leave the bundled GC archive symbols unresolved.
-							#flag @VEXEROOT/thirdparty/tcc/lib/libgc.dylib
-							#flag -Wl,-rpath,"@VEXEROOT/thirdparty/tcc/lib"
-						} $else {
-							// macOS amd64 tccbin only ships libgc.a (no .dylib).
-							#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
-						}
-					} $else {
-						#flag -L@VEXEROOT/thirdparty/tcc/lib
-						#flag -lgc
-						#flag -Xlinker -rpath -Xlinker "@VEXEROOT/thirdparty/tcc/lib"
-					}
-				} $else {
-					$if musl ? {
-						// The bundled tcc libgc archive is built for glibc and
-						// references __data_start/data_start, which musl does
-						// not provide. Alpine installs musl-compatible libgc.
-						$if tinyc {
-							// Prefer the shared library when present: Alpine's
-							// static libgc archive can leave weak data segment
-							// probes unresolved under tcc.
-							#flag $when_first_existing("/usr/lib/libgc.so", "/usr/local/lib/libgc.so", "/lib/libgc.so")
-						}
-						#flag -lgc
-					} $else {
-						#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
-					}
-				}
+				#flag @@HOMEBREW_PREFIX@@/lib/libgc.a
 			}
 		}
 		$if macos {
