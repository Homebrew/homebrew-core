class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.7.tar.gz"
  sha256 "8c67ae52c9c3926b16f0c64a046726c3d872de92add10b1ba1b0c4a659271be9"
  head "https://github.com/skywind3000/z.lua.git"

  bottle :unneeded

  depends_on "lua"

  def install
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
