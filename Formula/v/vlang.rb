class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.4.5.tar.gz"
  sha256 "3082ed68712c7d698e1cc19274b6428dc8c91963096aba01e5ff0321989a3040"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f81a749d6aa1e4cf91b53ce561960653523c068b4c8731b68b20e03dddcfb420"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b371f4e3eff3e4876e927460f5d8e4344072c39daf8866d8baa552410e920785"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad30259c9dd1945f0203fcab4a41d0ce5b0b7d0854bce23c8a3d2c04ce77bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f3770181a8e22a477f917c5ee106685842ec3ea9f7feec03b14868ca804e1f5"
    sha256 cellar: :any_skip_relocation, ventura:        "517f4714fcbfd3f0a9da6ab3ecd5808d87b961e879818e2c8c8478258647ef25"
    sha256 cellar: :any_skip_relocation, monterey:       "1a884b57461196e4c7afe1abfe25e64896131e31cc5e6e961c28d7b0d5da110c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947443ed1a2bf4f381d3ed108be25bbb5f5ba4927d08ca15177ceb4165a678b9"
  end

  depends_on "bdw-gc"

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "2386fe9a0d8cc92d0d013ecd81456f2831433a71"

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

    resource("vc").stage do
      system ENV.cc, "-std=gnu99", "-w", "-o", buildpath/"v1", "v.c", "-lm"
    end
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "cmd/v"
    system "./v2", "-o", buildpath/"v", "cmd/v"
    rm ["./v1", "./v2"]
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
index 0a13b64..23fca2b 100644
--- a/vlib/builtin/builtin_d_gcboehm.c.v
+++ b/vlib/builtin/builtin_d_gcboehm.c.v
@@ -31,12 +31,12 @@ $if dynamic_boehm ? {
 } $else {
 	$if macos || linux {
 		#flag -DGC_BUILTIN_ATOMIC=1
-		#flag -I @VEXEROOT/thirdparty/libgc/include
-		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
+		#flag -I @PREFIX@/include
+		$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
 			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
 			#flag @VEXEROOT/thirdparty/libgc/gc.o
 		} $else {
-			#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
+			#flag @PREFIX@/lib/libgc.a
 		}
 		$if macos {
 			#flag -DMPROTECT_VDB=1
