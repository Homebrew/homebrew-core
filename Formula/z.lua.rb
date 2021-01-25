class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.11.tar.gz"
  sha256 "213ea4c6287fa2952fb17db3191dcbaee014b28bff5230f615b23a1869aad912"
  license "MIT"
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
