class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.5.0.tar.gz"
  sha256 "e07634c7207dc51479d39895e546dd0107a50566faf5c2067f61a3b92c824fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b5220f190ab21c65e308ccee28de4ed4811fdacde23a98654cbb39433c8fd34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37bdb546a920a6c1c1fd70d047a37e872de2058469f4782cda61d349a28e00e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33983dedea1c7f4cec6bdc8b3a8814f58ac8da892a7bc415c98b1e441ecbe4f2"
    sha256 cellar: :any_skip_relocation, ventura:        "877e3024dcde145092ea3bd714766c3604fe17778df066af2081e9592da6a984"
    sha256 cellar: :any_skip_relocation, monterey:       "acd7800600cbf0326f2f792d647a119b7174c508d846ad694f7ea98decf48525"
    sha256 cellar: :any_skip_relocation, big_sur:        "41d08601121e1ebb24cedcc58596b4a89c5cfd66663848640b83f838eccdab84"
    sha256 cellar: :any_skip_relocation, catalina:       "fe527b88da1db127392fa45238013ec0b7152848ab17ee082d1e7bf03d2440c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96edc62c0602395ade99c3772fd371d7eb833c6e467c99236902f45014108dae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -v -X main.VERSION=#{version}"
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
