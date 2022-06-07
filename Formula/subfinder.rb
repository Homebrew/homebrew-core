class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.2.tar.gz"
  sha256 "3f99323effbbc0d8f1d5181ac4cc1c5bd31b50a1eb792866269ec44acf308f1d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f989c20846cbb92f2a8043e65dd0983a8661eecc2dd6a9dc014f05b0e36ac1d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "725087785fcee040aa761b1dca9181898c95895a48eb18da6b361a7cb7a9517b"
    sha256 cellar: :any_skip_relocation, monterey:       "d676ccd958202dbff5a37d30b26f2ab26c2e0e2ae17877d711931784b20db758"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a023742880227c798f5a71788ca03ba2066a15e9462015988a5552b1827d686"
    sha256 cellar: :any_skip_relocation, catalina:       "138af7cf381b382b4a8ca9286b8a00543f74c3b455b0f2d3511f8f434bb94eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16523ce07ed480354e4dc17f4a8d5094c0ffa9755e26c0c0cd2e6913df49c7d8"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
