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
    sha256                               arm64_tahoe:   "cc874e4768a2864b7e11fdc979890cf1d43523e5ff6a782b47f201754970bd20"
    sha256                               arm64_sequoia: "d76b8e73e5b582a058176d6f12191e7abc7f2b4abe1c34bc394aebe3d8a3204a"
    sha256                               arm64_sonoma:  "5bfe1fc97d00ead3636fb5a1bbe1eb86ea64675ecd4c89855f4591bf9d69cc72"
    sha256 cellar: :any,                 sonoma:        "2aa49153277c1f7e17cfb19417c7c1c90b2c1f1f01d2509ef4be49215e9df24c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144b1e72ec64c79b0ceb3d6a1b8288a82b4a7ad883d2d4e52ba46b18c5f3e0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bb6238dafb1c34d7a82966a929671284df9005d894cb13992777b4e131ba0b"
  end

  depends_on "bdw-gc"

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
      end
    end
  end

  # upstream discussion, https://github.com/vlang/v/issues/16776
  patch :DATA

  def install
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
      system ENV.cc, "-std=c99", "-w", "-o", buildpath/"v1", "v.c", "-lm", "-lpthread"
    end

    bootvfflag = OS.linux? ? ["-cc", ENV.cc] : []
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "-prod", *bootvfflag, "cmd/v"
    system "./v2", "-nocache", "-o", buildpath/"v", "-prod", "-d", "dynamic_boehm", *bootvfflag, "cmd/v"
    rm ["./v1", "./v2"]
    system "./v", "-prod", "-d", "dynamic_boehm", *bootvfflag, "build-tools"
    mv "vshare.v.orig", "cmd/tools/vshare.v" if OS.linux?

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
