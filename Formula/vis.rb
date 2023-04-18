class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.8.tar.gz"
  sha256 "61b10d40f15c4db2ce16e9acf291dbb762da4cbccf0cf2a80b28d9ac998a39bd"
  license "ISC"
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "e624a3eaeb09a8522138ac81ee9ad3b81ec1c7b6fd238cdea7194c2944e700d6"
    sha256 arm64_monterey: "004c30d61df29525fbe9a94ef464a9ae916f099e0a075f007865c0fe90ed5739"
    sha256 arm64_big_sur:  "95785ac7f450bed5ae94819aa7a85ac6dcc1951e35943aec9e11a3ce2cb9fced"
    sha256 ventura:        "f4569fef5ef9b0602698e5f502f9269eed63787255a51bc1282152020ae60869"
    sha256 monterey:       "9ff736b13ca53eba09c26c6e849b6f0583f2d72ef757f2fe28470f32f97383e6"
    sha256 big_sur:        "665268298b26ffa45e392f6a82f6be94378be38bd82c1cf2db7b7b7fbf94d36d"
    sha256 catalina:       "35216215a7cda04fea95361b9094031c9ed1598bae9267c4b7776d0772a56e2d"
    sha256 x86_64_linux:   "4834ecf328d90d800adf9b273af959d540b6b783bf5eb782ecdd3c73dbf64acd"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lua"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

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

    system "./configure", "--prefix=#{prefix}", "--enable-lua"
    system "make", "install"

    luaenv = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", luaenv)

    if OS.mac?
      # Rename vis & the matching manpage to avoid clashing with the system.
      mv bin/"vis", bin/"vise"
      mv man1/"vis.1", man1/"vise.1"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid a name conflict with the macOS system utility /usr/bin/vis,
        this text editor must be invoked by calling `vise` ("vis-editor").
      EOS
    end
  end

  test do
    binary = if OS.mac?
      bin/"vise"
    else
      bin/"vis"
    end

    assert_match "vis #{version} +curses +lua", shell_output("#{binary} -v 2>&1")
  end
end
