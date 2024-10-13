class Wxlua < Formula
  desc "Lua bindings for wxWidgets cross-platform GUI toolkit"
  homepage "https://github.com/pkulchenko/wxlua"
  url "https://github.com/pkulchenko/wxlua/archive/refs/tags/v3.2.0.2.tar.gz"
  sha256 "62abe571803a9748e19e86e39cb0e254fd90a5925dc5f0e35669e693cbdb129e"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  head "https://github.com/pkulchenko/wxlua.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "eb6bd23314e5fae0077a40d2b2e749ccb5961a4d54c1271c08ecd35d7c90741f"
    sha256 cellar: :any, arm64_sonoma:   "9b88dcbd675bd41b9587b2756e9723ff7773c8352d32716c6635977cf8e2928c"
    sha256 cellar: :any, arm64_ventura:  "8323cdc3eb417a827b0573b09ec1ac9174363c34391aab08400ebb441a315136"
    sha256 cellar: :any, arm64_monterey: "275d472881910487ba3690284d876e350cd9bb0de114d721e025615226a8a370"
    sha256 cellar: :any, arm64_big_sur:  "24446df354b9fdeff4c0029e14ceecfce69d92489f14487332ac13a78f0944f7"
    sha256 cellar: :any, sonoma:         "37568c2f9d8c6bfce5878ba307a181e72aa14f9b2ba4f61dc246699260dc4af9"
    sha256 cellar: :any, ventura:        "abb35ae9d330fac24f731b2e5ce0e2bf9821bb96411d810991432c04de96ae24"
    sha256 cellar: :any, monterey:       "85fa21b8ff57b2e09b939aa9cdddb4de18499bc88d8ce52f65d248e70aef62b9"
    sha256 cellar: :any, big_sur:        "5aecd415ce2705001e6ff73cabc0e40f35979e52b4c7962c302779af7d4dd408"
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "wxwidgets"

  def install
    lua = Formula["lua"]
    wxwidgets = Formula["wxwidgets"]
    lua_version = lua.version.major_minor

    args = %W[
      -DwxLua_LUA_LIBRARY_VERSION=#{lua_version}
      -DwxLua_LUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DwxLua_LUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DwxWidgets_CONFIG_EXECUTABLE=#{wxwidgets.opt_bin}/wx-config
      -DwxLua_LUA_LIBRARY_USE_BUILTIN=FALSE
    ]

    system "cmake", "-S", "wxLua", "-B", "build-wxlua", *args, *std_cmake_args
    system "cmake", "--build", "build-wxlua"
    system "cmake", "--install", "build-wxlua"

    (lib/"lua"/lua_version).install lib/shared_library("libwx") => "wx.so"
    prefix.install bin.glob("*.app")
  end

  test do
    (testpath/"example.wx.lua").write <<~EOS
      require('wx')
      print(wxlua.wxLUA_VERSION_STRING)
    EOS

    assert_match "wxLua #{version}", shell_output("lua example.wx.lua")
  end
end
