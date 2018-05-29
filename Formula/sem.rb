class Sem < Formula
  desc "Command-line tool to manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/0.9.38.tar.gz"
  sha256 "fd40b9c15f8c20e68fade6ffe3ef5191873b4531da0d0c8c67474dc1e28fddc7"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  test do
    assert_equal "0.9.38", shell_output("#{bin}/sem-info version").chomp
  end
end
