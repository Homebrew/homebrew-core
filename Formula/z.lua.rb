class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.15.tar.gz"
  sha256 "48f7f2ba185eb4190268ef66782574c1bef70b131c37413f722cb60297444849"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e08196107f477f8f17de02d0b99de9181095036be6137a9533d46bf88cf9889c"
  end

  depends_on "lua"

  def install
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
