class TitanServer < Formula
  desc "Distributed graph database"
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-1.0.0-hadoop1.zip"
  version "1.0.0"
  sha256 "67538e231db5be75821b40dd026bafd0cd7451cdd7e225a2dc31e124471bb8ef"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad979abf4355375d61b23ec670d548680090f6d8ce4616c00f6c039fa99a1838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6d98726b834d82fe0adb786919652c5f0e0974ff3cb03969b2c69042cd4998c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d152d5cdf3a9a8f600f9956f9e1687a4cbcccbda4398c69ddde2d44a42d43723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d152d5cdf3a9a8f600f9956f9e1687a4cbcccbda4398c69ddde2d44a42d43723"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa9d2a7bdbbec0244fe31f207bcf289a8453fb9e8786239669180e5b867450df"
    sha256 cellar: :any_skip_relocation, ventura:        "11f1ceef4d191f1bf683fdec2a0cff3ffff8510b373e83fa12065af581583e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "6e84706c4de8f9288fe11a9c28d0b6901289ce45ddcd7ff51abc1ecfcc6f3ac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e84706c4de8f9288fe11a9c28d0b6901289ce45ddcd7ff51abc1ecfcc6f3ac3"
    sha256 cellar: :any_skip_relocation, catalina:       "6e84706c4de8f9288fe11a9c28d0b6901289ce45ddcd7ff51abc1ecfcc6f3ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d98726b834d82fe0adb786919652c5f0e0974ff3cb03969b2c69042cd4998c"
  end

  # upstream is not responsive on the issues and no commits since 2015 dec
  # community has forked the project to janusgraph
  # https://github.com/thinkaurelius/titan/issues/1393
  # https://github.com/thinkaurelius/titan/issues/1392
  disable! date: "2025-01-01", because: :does_not_build

  on_linux do
    depends_on "openjdk"
  end

  def install
    libexec.install %w[bin conf data ext javadocs lib log scripts]
    bin.install_symlink libexec/"bin/titan.sh" => "titan"
    bin.install_symlink libexec/"bin/gremlin.sh" => "titan-gremlin"
    bin.install_symlink libexec/"bin/gremlin-server.sh" => "titan-gremlin-server"
  end

  test do
    assert_match("not found in the java process table", shell_output("#{bin}/titan stop"))
  end
end
