class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.5.tar.gz"
  sha256 "77ea70ebc9c811d88e32199ef5b3ee9b834ac1e880fb61b6d2460f93f0587df5"
  head "https://github.com/martanne/vis.git"

  bottle do
    rebuild 1
    sha256 "653477cccc87df049b8dad710c07e4f62ea4b228c31ac6781a1f7ef289efeff4" => :catalina
    sha256 "93c11117e6a40af5059b02810737dbb1cd494a1eae88acc0d0230d0afeae4768" => :mojave
    sha256 "da6c3c09d9b53f77c0aecbdd99d145447ed12505f3d2103532502415b53f4564" => :high_sierra
    sha256 "831f3f4424b231e086784a1741eb1bdc94b5134fa220176a24848f7f226634ab" => :sierra
    sha256 "d902e9dbb59c21ab7b8d3476c9125a160c8633599ed1097caa001f32ac50f3b4" => :el_capitan
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lua"

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock"
    sha256 "149be31e0155c4694f77ea7264d9b398dd134eca0d00ff03358d91a6cfb2ea9d"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resource("lpeg").stage do
      system "luarocks", "build", "lpeg", "--tree=#{luapath}"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    env = { :LUA_PATH => ENV["LUA_PATH"], :LUA_CPATH => ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", env)
    # Rename vis & the matching manpage to avoid clashing with the system.
    mv bin/"vis", bin/"vise"
    mv man1/"vis.1", man1/"vise.1"
  end

  def caveats
    <<~EOS
      To avoid a name conflict with the macOS system utility /usr/bin/vis,
      this text editor must be invoked by calling `vise` ("vis-editor").
    EOS
  end

  test do
    assert_match "vis v#{version} +curses +lua", shell_output("#{bin}/vise -v 2>&1")
  end
end
