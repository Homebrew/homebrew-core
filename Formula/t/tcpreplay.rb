class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.5.2/tcpreplay-4.5.2.tar.gz"
  sha256 "ccff3bb29469a04ccc20ed0b518e3e43c4a7b5a876339d9435bfd9db7fe5d0f1"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b176ea94713287877a7ea7070827e6c878b02dc5b041fbb72d86959844067489"
    sha256 cellar: :any,                 arm64_sequoia: "e1d0937d05aafd45c31f68cc66122d3bbd37d7fddca7772af45bd17f9d7ad16b"
    sha256 cellar: :any,                 arm64_sonoma:  "151b9f95a3924504efbd0458e1136d24eee4555989cacd7f3289daaae63c1d8e"
    sha256 cellar: :any,                 arm64_ventura: "bebe392ee113e4351695149aa69c3a5f49a23141e29d5a1d87653994add8266c"
    sha256 cellar: :any,                 sonoma:        "02f52b95155aa75b197e8c1c726acb334c3f3c24bf76fcd1823bed6610afbc0e"
    sha256 cellar: :any,                 ventura:       "8c7ab5e0ffd729cda025aa995fa9bb607c47170d44c41dc438f82f1032cd22f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7adebd39df6e58f28d5da9cb969966b411a6e6dcf844e0fc65956ce9fea96a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1602f54ea30d09b224bf50cb03fd4c505aafc866a73a8eb58182bca38dae5dbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  on_sonoma :or_older do
    # Fix build failure due to signature mismatch for `TAILQ_FOREACH_REVERSE`
    # between the bundled `queue.h` and system `queue.h`.
    # https://github.com/appneta/tcpreplay/issues/981
    patch :DATA
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end

__END__
diff --git i/src/fragroute/mod.c w/src/fragroute/mod.c
index e7effdc6..ed6feb7d 100644
--- i/src/fragroute/mod.c
+++ w/src/fragroute/mod.c
@@ -177,7 +177,7 @@ mod_close(void)
 {
     struct rule *rule;
 
-    TAILQ_FOREACH_REVERSE(rule, &rules, next, head)
+    TAILQ_FOREACH_REVERSE(rule, &rules, head, next)
     {
         if (rule->mod->close != NULL)
             rule->data = rule->mod->close(rule->data);
