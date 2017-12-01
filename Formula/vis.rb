class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  head "https://github.com/martanne/vis.git"

  stable do
    url "https://github.com/martanne/vis/archive/v0.4.tar.gz"
    sha256 "f11ba41cfb86dd39475960abfd12469de4da0ccfdb941f1d7680d89d987694c5"

    patch do
      url "https://github.com/martanne/vis/commit/73ef4885.patch?full_index=1"
      sha256 "639f2b5ff708327c5d6b5b7d198b24cb4a71a72ae935a92bd765bd532c755603"
    end
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

    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    (bin/"vise").write <<~EOS
      #!/bin/sh
      VIS_BASE=#{libexec}
      VIS_PATH=$VIS_BASE/share/vis $VIS_BASE/bin/vis $@
    EOS
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
