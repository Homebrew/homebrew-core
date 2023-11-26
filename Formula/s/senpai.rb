class Senpai < Formula
  desc "Modern terminal IRC client"
  homepage "https://sr.ht/~taiite/senpai/"
  url "https://git.sr.ht/~taiite/senpai/archive/v0.2.0.tar.gz"
  sha256 "9786fd83f3e1067549c3c88455a1f66ec66d993fe597cee334d217a5d1cf4803"
  license "ISC"

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def uninstall
    system "make", "PREFIX=#{prefix}", "uninstall"
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/bin/senpai", shell_output("which senpai").strip
  end
end
