class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/refs/tags/1.8.20.tar.gz"
  sha256 "3d5afb8d617e956ac7385e2cd5082991630705566ddc0871295404e16a05445c"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bdc00251d242da7b480b8cd81e8f029cb105cb63cb9afc358ea1586c6ecd1195"
  end

  depends_on "lua"

  def install
    # Avoid using Cellar paths at runtime. This breaks when z.lua is upgraded.
    inreplace "z.lua.plugin.zsh", /^(ZLUA_SCRIPT=").*"$/, "\\1#{opt_pkgshare}/z.lua\""
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  def caveats
    <<~EOS
      Zsh users: add line below to your ~/.zshrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init zsh)"

      Bash users: add line below to your ~/.bashrc
        eval "$(lua $(brew --prefix z.lua)/share/z.lua/z.lua --init bash)"
    EOS
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
