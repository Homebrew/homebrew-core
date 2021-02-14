class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/2.8.12.tar.gz"
  sha256 "5092f186bf23e92437f3fed8bc5862a1e92ebfa322b7aed56887af9029bf6770"
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
