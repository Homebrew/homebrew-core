class Tzdiff < Formula
  desc "Displays Timezone differences with localtime in CLI (shell script)"
  homepage "https://github.com/belgianbeer/tzdiff"
  url "https://github.com/belgianbeer/tzdiff/archive/1.2.tar.gz"
  sha256 "6c3b6afc2bb36b001ee11c091144b8d2c451c699b69be605f2b8a4baf1f55d0a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, ventura:        "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, monterey:       "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "653e627cd07a9e45f405a5d49c852eb00b19e1ed66253bf37329b028388c56cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0325053015b97d2c15992d83cdda4ca756fede5fc9d852ed925e42de045f847b"
  end

  def install
    bin.install "tzdiff"
    man1.install "tzdiff.1"
  end

  test do
    assert_match "Asia/Tokyo", shell_output("#{bin}/tzdiff -l Tokyo")
    assert_match version.to_s, shell_output("#{bin}/tzdiff -v")
  end
end
