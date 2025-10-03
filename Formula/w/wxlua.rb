class Wxlua < Formula
  desc "Lua bindings for wxWidgets cross-platform GUI toolkit"
  homepage "https://github.com/pkulchenko/wxlua"
  url "https://github.com/pkulchenko/wxlua/archive/refs/tags/v3.2.0.2.tar.gz"
  sha256 "62abe571803a9748e19e86e39cb0e254fd90a5925dc5f0e35669e693cbdb129e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 2
  head "https://github.com/pkulchenko/wxlua.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f63c60c406c9dae244b02faed0197cac05750d67d8b8cce6b7ef409552375d2"
    sha256 cellar: :any,                 arm64_sequoia: "bab4b714917c8eaa227c442ec73933b7a7366a9a0b12194775f5d5ed51afad32"
    sha256 cellar: :any,                 arm64_sonoma:  "c5fad089244f71343cbb95de5a40af99d9bfaa9d74eea565945794c0a6b3a9fd"
    sha256 cellar: :any,                 arm64_ventura: "850b90ff67e8cf4d2ff3c4be320a639e289a5a89edc0f0e2835baab13a5ece9c"
    sha256 cellar: :any,                 sonoma:        "3c3912fba2919d8b041b502c10f077c54cba423e30c2d055606d341077d693bf"
    sha256 cellar: :any,                 ventura:       "f2edee1dfc8cc68afa93490705f6250dbc688a0a004e723fa8e6429b6614da39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148fb602637b776ef7e3d48eae4c4289de06f3985166176e9d8eee98ff86f6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f08d50a654d1506fd6e0212b629e49a1b8bd3ff910b0317826540ff4a03832"
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "wxwidgets@3.2"

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    lua = Formula["lua"]
    lua_version = lua.version.major_minor
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"

    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DwxLua_LUA_LIBRARY_VERSION=#{lua_version}
      -DwxLua_LUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DwxLua_LUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DwxWidgets_CONFIG_EXECUTABLE=#{wx_config}
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
