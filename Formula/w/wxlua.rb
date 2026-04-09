class Wxlua < Formula
  desc "Lua bindings for wxWidgets cross-platform GUI toolkit"
  homepage "https://github.com/pkulchenko/wxlua"
  url "https://github.com/pkulchenko/wxlua/archive/refs/tags/v3.2.0.2.tar.gz"
  sha256 "62abe571803a9748e19e86e39cb0e254fd90a5925dc5f0e35669e693cbdb129e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 3
  head "https://github.com/pkulchenko/wxlua.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5615d825d18fa290ebb828623ad3276ab34c5943ad08c5cad47191afe7d6e2a8"
    sha256 cellar: :any,                 arm64_sequoia: "32e47f1afc987ec94238af58e9e269fb9b5fec627251a96c02c482dd6e44ca44"
    sha256 cellar: :any,                 arm64_sonoma:  "519c48b22ff8db3692f2a24aa0580711d7f58fde5f177459eaf5829bd308c2b6"
    sha256 cellar: :any,                 sonoma:        "4b4a90537713c21f36a328dc40b3bad2382a15cbf7a4bf67d784f2b351304584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0c694a5941b36927f4912323c7346d230d145e92a88df37e6a1c6a63c948e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71f373105d739d9bc0a282e11d6bf117ace64b56cbb60268f4f39141f5631bb"
  end

  depends_on "cmake" => :build
  depends_on "lua@5.4"
  depends_on "wxwidgets@3.2"

  on_linux do
    depends_on "xorg-server" => :test
  end

  def lua
    Formula["lua@5.4"]
  end

  def install
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

    assert_match "wxLua #{version}", shell_output("#{lua.bin}/lua example.wx.lua")
  ensure
    Process.kill("TERM", xvfb_pid) if xvfb_pid
  end
end
