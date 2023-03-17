class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.7.tar.gz"
  sha256 "6ff2b05189727ab3bd8e3391b7c5c9c4ae2079a81e766f509fe21033c435134d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e070c1dbb453fce3b0825f8826ccd944b8795929050ee9d0e358a4625e20583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e070c1dbb453fce3b0825f8826ccd944b8795929050ee9d0e358a4625e20583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e070c1dbb453fce3b0825f8826ccd944b8795929050ee9d0e358a4625e20583"
    sha256 cellar: :any_skip_relocation, ventura:        "88fb095e44e3f2648592684e7f9d366aab8461a88719a86dbdd40a9916eb7ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "88fb095e44e3f2648592684e7f9d366aab8461a88719a86dbdd40a9916eb7ecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "88fb095e44e3f2648592684e7f9d366aab8461a88719a86dbdd40a9916eb7ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf84b4f728805ffe145360033d297630944a6d50b3f78bb2ec5bb8b0008ae15"
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
