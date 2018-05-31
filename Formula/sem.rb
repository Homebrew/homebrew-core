class Sem < Formula
  desc "Command-line tool to manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.39.tar.gz"
  sha256 "1f48ec409aa6dcdd05d2aef07ae5d7d6a97de510433bc6402a4f0b1bced5ad18"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  test do
    assert_equal "0.9.39", shell_output("#{bin}/sem-info version").chomp
  end
end
