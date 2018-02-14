class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  revision 2

  head "https://github.com/martanne/vis.git"

  stable do
    url "https://github.com/martanne/vis/archive/v0.4.tar.gz"
    sha256 "f11ba41cfb86dd39475960abfd12469de4da0ccfdb941f1d7680d89d987694c5"

    patch do
      url "https://github.com/martanne/vis/commit/73ef4885.patch?full_index=1"
      sha256 "639f2b5ff708327c5d6b5b7d198b24cb4a71a72ae935a92bd765bd532c755603"
    end
  end

  bottle do
    sha256 "3ae7e1e1213928f4c6fbac2e24c797ac69b0c711cc29011ceaf515a9ce9dd39c" => :high_sierra
    sha256 "c8c60ae96962570361c5a7dbaf3aab5d3ea408d9560d1b007d2b11c42316d8d3" => :sierra
    sha256 "9668e33187b9a55dfc67bcf39604d7bc9559fa1bd0e16fa7e33e1772b45f3afb" => :el_capitan
  end

  depends_on "libtermkey"
  depends_on "lua"

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock", :using => :nounzip
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

  def caveats; <<~EOS
    To avoid a name conflict with the macOS system utility /usr/bin/vis,
    this text editor must be invoked by calling `vise` ("vis-editor").
  EOS
  end

  test do
    assert_match "vis v#{version} +curses +lua", shell_output("#{bin}/vise -v 2>&1")
  end
end
