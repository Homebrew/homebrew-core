class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.10.tar.gz"
  sha256 "5315074e622c082b78461f354caa0980b17268eb2aae69fd0aa7d2a29ade8ddd"
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
