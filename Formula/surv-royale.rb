class SurvRoyale < Formula
  desc "desktop clone of surviv.io written in C++"
  homepage "https://github.com/Fenex330/surv-royale"
  url "https://github.com/Fenex330/surv-royale/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "e2977edff3e1b855845230695839f16a055c6a952de2fbd9d7d9b733ca8629b6"
  license "MIT"
  head "https://github.com/Fenex330/surv-royale.git", branch: "master"

  depends_on "sfml"

  def install
    system "make"
    system "make", "install"
  end
end
