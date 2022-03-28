class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.15.tar.gz"
  sha256 "48f7f2ba185eb4190268ef66782574c1bef70b131c37413f722cb60297444849"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "468b67837221e43d91b09561ea571862c7c2832400e6522452444ca52ab17e0d"
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
