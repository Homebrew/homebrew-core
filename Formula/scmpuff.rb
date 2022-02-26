class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.5.0.tar.gz"
  sha256 "e07634c7207dc51479d39895e546dd0107a50566faf5c2067f61a3b92c824fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb55c67fdaedbce13f78ac544a998fed18dc96038e3b0e68dbe14b758f02e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d14133971e78b28d3c1c6531b2bd6b30553301fcae87cd7ff8b6adfc09cd5677"
    sha256 cellar: :any_skip_relocation, monterey:       "590f950e4e67a3f87c7eafd1e028bd22213f7e106d140d35f3270fdd8dd0f12b"
    sha256 cellar: :any_skip_relocation, big_sur:        "08cd314e495b756c9a76621a10f2b53264b9f9983f80ac265362e068c878d647"
    sha256 cellar: :any_skip_relocation, catalina:       "736e0f055819fc55cfaf66435781ebb824758f3e88d8ae6c098fc0181f92ae83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e98d0e836cc48d1080f3bb4229a1981fd7b90abd9e31673c0144f91b5bf3b9"
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
