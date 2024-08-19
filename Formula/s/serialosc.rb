class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.4",
      revision: "19ad3a211876c4434346ab2565eeec09cc949856"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9d79b6270b3a2e19e0154148b34f315f4396e62795d13ea6ed30306ee4e152e"
    sha256 cellar: :any,                 arm64_ventura:  "dfc2861176110ab1853c2cd2f196f2081570b8280b27cd246a29d8d1879f8ce5"
    sha256 cellar: :any,                 arm64_monterey: "972d810857722ce1b6fa7dd49f9a3b62623d81269267913bea17cbe845e35413"
    sha256 cellar: :any,                 sonoma:         "203065f92d72654c7e957e3742b8df010254f4bdb5ead9f1b6ff8883c4ee0ad5"
    sha256 cellar: :any,                 ventura:        "1be36c6a1de9496207dc9697788252f7b31036bad06a21683bf11bc5ee2534c2"
    sha256 cellar: :any,                 monterey:       "d87477eb3bade445735ddae8ff084f67f376293fb744782f03895e398a96f280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b10b96744fac9f1e5e476ab8d1600b963bdbbc1c54f25a8835cee647355d19"
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi"
    depends_on "systemd" # for libudev
  end

  # Uses fmemopen API (High Sierra) but defining a target macOS version of Leopard:
  # https://github.com/monome/serialosc/pull/71
  patch :DATA

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
__END__
diff --git a/wscript b/wscript
index 5026c5c..8af6e84 100644
--- a/wscript
+++ b/wscript
@@ -272,8 +272,8 @@ def configure(conf):
 					'-Wl,--enable-stdcall-fixup'])
 		conf.env.append_unique("WINRCFLAGS", ["-O", "coff"])
 	elif conf.env.DEST_OS == "darwin":
-		conf.env.append_unique("CFLAGS", ["-mmacosx-version-min=10.5"])
-		conf.env.append_unique("LINKFLAGS", ["-mmacosx-version-min=10.5"])
+		conf.env.append_unique("CFLAGS", ["-mmacosx-version-min=10.13"])
+		conf.env.append_unique("LINKFLAGS", ["-mmacosx-version-min=10.13"])
 
 	if conf.options.disable_zeroconf:
 		conf.define("SOSC_NO_ZEROCONF", True)
