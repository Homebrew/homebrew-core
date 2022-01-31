class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.14.tar.gz"
  sha256 "93784896021f84efe8430fbfcd9f0238426600d62a88780a1abda97943822bd5"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e81f502f0d1aa8fcc350be77777e7dc6ee05bd04906762f4ce9a3fc285ceba5"
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
