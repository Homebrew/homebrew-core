class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.6.tar.gz"
  sha256 "9ab4a3f1c5953475130b3c286af272fe5cfdf7cbb7f9fbebd31e9ea4f34e487d"
  head "https://github.com/martanne/vis.git"

  bottle do
    sha256 "370791e6f8c70327d9afc8049fe8f8ff16a9e843835efe9f606dbdef6c2319f3" => :catalina
    sha256 "3f39518139d63c87a5a499a3ae53829bde4ed1b1eecbc5344d1bfe883ea16b7c" => :mojave
    sha256 "166b64aad19e64712cfbf1f3da60cebf1fb6351b3f32921aa10060081cbcef3a" => :high_sierra
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

    env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
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
