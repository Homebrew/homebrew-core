class Wxlua < Formula
  desc "Lua bindings for wxWidgets cross-platform GUI toolkit"
  homepage "https://github.com/pkulchenko/wxlua"
  url "https://github.com/pkulchenko/wxlua/archive/refs/tags/v3.2.0.2.tar.gz"
  sha256 "62abe571803a9748e19e86e39cb0e254fd90a5925dc5f0e35669e693cbdb129e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1
  head "https://github.com/pkulchenko/wxlua.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ab53a21ffd382cb7d53a884b4eb09df5484c36d106c452f03c75f8841726d5c"
    sha256 cellar: :any,                 arm64_sonoma:  "c00c2ef44ed734d26861a29d800555455f86c7fd8d846f12ecc6b4f0d151bd37"
    sha256 cellar: :any,                 arm64_ventura: "e4c38bdfbbd990e273116a570fe63200cc78fbd6fa1e1b051b45d5a699060168"
    sha256 cellar: :any,                 sonoma:        "3f5fd12035ae6a1f09efbefc9e5c7658898a48c228c5383a836d6d975833cced"
    sha256 cellar: :any,                 ventura:       "debb18bebc1fe2d3ef3fd6ca8810c141ecb94cd6d0d1666112366e604a396307"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e29b1f1b1629fb2324d601f1e7d8054da3fbbc0050b841d9da48db9857bae5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6c83b3e941528b906e9007ec23d4fec5506953aa6b77dc5877037ab2ec229e"
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "wxwidgets"

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    lua = Formula["lua"]
    wxwidgets = Formula["wxwidgets"]
    lua_version = lua.version.major_minor

    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DwxLua_LUA_LIBRARY_VERSION=#{lua_version}
      -DwxLua_LUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DwxLua_LUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DwxWidgets_CONFIG_EXECUTABLE=#{wxwidgets.opt_bin}/wx-config
      -DwxLua_LUA_LIBRARY_USE_BUILTIN=FALSE
    ]
    # Some components are not enabled in brew `wxwidgets`:
    # * webview - needs `webkitgtk` dependency
    # * media   - needs `gstreamer` dependency
    args << "-DwxWidgets_COMPONENTS=gl;stc;xrc;richtext;propgrid;html;aui;adv;core;xml;net;base" if OS.linux?

    system "cmake", "-S", "wxLua", "-B", "build-wxlua", *args, *std_cmake_args
    system "cmake", "--build", "build-wxlua"
    system "cmake", "--install", "build-wxlua"

    (lib/"lua"/lua_version).install lib/shared_library("libwx") => "wx.so"
    prefix.install bin.glob("*.app")
  end

  test do
    (testpath/"example.wx.lua").write <<~LUA
      require('wx')
      print(wxlua.wxLUA_VERSION_STRING)
    LUA

    if OS.linux?
      xvfb_pid = spawn Formula["xorg-server"].bin/"Xvfb", ":1"
      ENV["DISPLAY"] = ":1"
      sleep 10
    end

    assert_match "wxLua #{version}", shell_output("lua example.wx.lua")
  ensure
    Process.kill("TERM", xvfb_pid) if xvfb_pid
  end
end
