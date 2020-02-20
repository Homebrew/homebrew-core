class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "https://dotat.at/prog/unifdef/"
  url "https://dotat.at/prog/unifdef/unifdef-2.12.tar.gz"
  sha256 "fba564a24db7b97ebe9329713ac970627b902e5e9e8b14e19e024eb6e278d10b"
  head "https://github.com/fanf2/unifdef.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa00861707fcd190d148f1adbdb2de40c87c8d76fffc14943546b7cfe95e4645" => :catalina
    sha256 "a4f1251e49839d04791e90a1a6c72d72679ebad399ca8cc184aae7f729ce518e" => :mojave
    sha256 "a7e42f5a8e2c467e84dbf9edc4f14cad362850e324088844d6b11f1cae88ce9f" => :high_sierra
    sha256 "be948ffc760273a09943faa7c156e4014534da82c78bc2c3c4f2a4a4416e962e" => :sierra
    sha256 "a89e5cc9b179fa5135077ad0c27e34cebe13a33dc02adccab4969855ba173357" => :el_capitan
    sha256 "3277bf0977c385e3cf5ccf3355e11f30b057c58d8539a27d5a23531ce7de9542" => :yosemite
    sha256 "8533d1ce7b70e51256a3c24d557345b7b7ac0b7e6562de5a0f942c058ae518db" => :mavericks
  end

  keg_only :provided_by_macos, "the unifdef provided by Xcode cannot compile gevent"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
