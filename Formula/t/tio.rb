class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.7/tio-3.7.tar.xz"
  sha256 "dbaef5dc6849229ce4eb474d4de77a7302cd2b0657731a8df86a44dd359e6afb"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "1afc83c0a8e2ec3ba362252dd4f5200a3cef1c1c00708fee1178789146edce85"
    sha256 cellar: :any, arm64_sonoma:   "89f23caa67345fc27f68a17f75bc9571cc923c010ae5788aa801d396cb74293d"
    sha256 cellar: :any, arm64_ventura:  "a365cc8f1ea4e4096377bc049a09205b5335a04975b29e619c6e62231e00db24"
    sha256 cellar: :any, arm64_monterey: "ee6b98c13cfa6b4bb44c79a1415bf079ea469eed38556573414db3eb072d0761"
    sha256 cellar: :any, sonoma:         "3cd0fe7d4f2e86aa7d27a57870dc1f655db87eba6186c04191cc082ad0b4b4d0"
    sha256 cellar: :any, ventura:        "68f03dbd5e8c0a1bcbcf174a075d3ed8045f7ff6c4befa7372a5da5db72c2ebd"
    sha256 cellar: :any, monterey:       "0ed639827a0e5c06d81aa6b9b9e8718644eb695ba5b2f1ec37bad35bb0d80661"
    sha256               x86_64_linux:   "ec8d34efee793539378e9b80346e58ca4faaeb5dcc6e84f427ffbcbe0940f29b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "lua"

  # fix function name conflict with system `send()`
  # upstream bug report, https://github.com/tio/tio/issues/278
  patch :DATA

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end

__END__
diff --git a/src/script.c b/src/script.c
index 46e6c4e..bfac3d9 100644
--- a/src/script.c
+++ b/src/script.c
@@ -181,7 +181,7 @@ static int modem_send(lua_State *L)
 }

 // lua: send(string)
-static int send(lua_State *L)
+static int send_lua(lua_State *L)
 {
     const char *string = lua_tostring(L, 1);
     int ret;
@@ -455,7 +455,7 @@ static const struct luaL_Reg tio_lib[] =
     { "msleep", msleep},
     { "line_set", line_set},
     { "modem_send", modem_send},
-    { "send", send},
+    { "send", send_lua},
     { "read", read_string},
     { "expect", expect},
     { "exit", exit_},
