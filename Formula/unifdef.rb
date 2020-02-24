class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "https://dotat.at/prog/unifdef/"
  url "https://dotat.at/prog/unifdef/unifdef-2.12.tar.gz"
  sha256 "fba564a24db7b97ebe9329713ac970627b902e5e9e8b14e19e024eb6e278d10b"
  head "https://github.com/fanf2/unifdef.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae908aa0c1845ce059576df3922808db790fb0ea91109f89aa930c8da7a68904" => :catalina
    sha256 "ded3ae5ba762ee493fc5ed45d0e6ed5a8261b4bf9bc2de54880f4a373b1ba075" => :mojave
    sha256 "74ec90a8fc2467e8d613f2a6347d973dcd6387fdd9734bc66088a64ace7e0d4d" => :high_sierra
  end

  keg_only :provided_by_macos, "the unifdef provided by Xcode cannot compile gevent"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
