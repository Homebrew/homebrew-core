class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.12.tar.gz"
  sha256 "1c3d871bf625b5a2eef9ecbb4face9d6432565d05ea8d26322b7a65b2e1d99d2"
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
