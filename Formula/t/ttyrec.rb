class Ttyrec < Formula
  desc "Terminal interaction recorder and player"
  homepage "http://0xcc.net/ttyrec/"
  url "http://0xcc.net/ttyrec/ttyrec-1.0.8.tar.gz"
  sha256 "ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec"
  license "BSD-4-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=["']?ttyrec[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b44b170e50cd4a45a34866f55c074aa7178b26a733350d471dff58709831cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1bc483dbae460cdc63985077a07ab767d1f3b3b2d614ef276a038a07bbaa479c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d151676ce6f3761eb16f59d01ebfc1504d63477695f5b5c8d178a0d5c095139a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da60792e0827bc948f8f1f0ce1f4c2e223e987c62943e8d854887d2b3557de4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ae3690abbab9b59cd40c4a0004f21c5277c5642484fed77c180115030fa637e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5538f4c65b9395dd35a7d9f975a7da59a9e9b1bc4cf09725b86d61c48755306a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e9bd8f7c2282ae05b62d8e632eca528d483830ecaadd072d8fa9de280720585"
    sha256 cellar: :any_skip_relocation, ventura:        "e9de3489dab176b7c6335e02bf2e58dbc83a31687a714af08ec3a4c4d5cd4be1"
    sha256 cellar: :any_skip_relocation, monterey:       "2e9366729fa85940745e55645c77c6f22c2ba47ad356159e5fc5564988e88e0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc7756b323c5faf2006093ac2873d7805f5ddfc06df6bf5bcbcdd4fa70b2c328"
    sha256 cellar: :any_skip_relocation, catalina:       "6d893647087afa85234f60103507a5a878360d018816c557534d469c4edf7bf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea3a96ddfe71319d95009cd84257f98d42a335e692aea071b9d9a718e2d58a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd1acdb4519d34c1b28fced057623dcd6457c60def91150fd042ed6be04e481"
  end

  resource "matrix.tty" do
    url "http://0xcc.net/tty/tty/matrix.tty"
    sha256 "76b8153476565c5c548aa04c2eeaa7c7ec8c1385bcf8b511c68915a3a126fdeb"
  end

  # Fixes "ttyrec.c:209:20: error: storage size of ‘status’ isn’t known";
  # check `man 2 wait3`.
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # macOS has openpty() in <util.h>
    # Reported by email to satoru@0xcc.net on 2017-12-20
    inreplace "ttyrec.c", "<libutil.h>", "<util.h>" if OS.mac?

    # openpty is a BSD function
    ENV.append_to_cflags "-DHAVE_openpty" if OS.mac?

    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install %w[ttytime ttyplay ttyrec]
    man1.install Dir["*.1"]
  end

  test do
    resource("matrix.tty").stage do
      assert_equal "9\tmatrix.tty", shell_output("#{bin}/ttytime matrix.tty").strip
    end
  end
end

__END__
--- a/ttyrec.c
+++ b/ttyrec.c
@@ -203,11 +203,7 @@ doinput()
 void
 finish()
 {
-#if defined(SVR4)
 	int status;
-#else /* !SVR4 */
-	union wait status;
-#endif /* !SVR4 */
 	register int pid;
 	register int die = 0;
 
