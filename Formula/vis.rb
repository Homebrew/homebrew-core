class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.7.tar.gz"
  sha256 "359ebb12a986b2f4e2a945567ad7587eb7d354301a5050ce10d51544570635eb"
  license "ISC"
  head "https://github.com/martanne/vis.git"

  bottle do
    sha256 "4aeb0308a6d979940de003d4c2013c5c5b85eecf600b5f44351f5dae5bdfa99d" => :big_sur
    sha256 "38e336f42ba65ee1cc621b885d364b0568fe8522ddf0ad370425b4409bc41f81" => :arm64_big_sur
    sha256 "801a96b4aa47cbe0196af84017177d9e3bde18561a75bcf3e7bee970c491973a" => :catalina
    sha256 "4abbde51b5cf5b4451678d2d4a6d8c1279c64cac44970b3715416beffb726b0f" => :mojave
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
    # Make sure I point to the right version!
    lua = Formula["lua"]

    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/#{lua.version.major_minor}/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{lua.version.major_minor}/?.so"

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
