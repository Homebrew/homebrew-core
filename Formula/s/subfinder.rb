class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.6.3.tar.gz"
  sha256 "bd587a7545504949b18e7bf781fe4165e62785881a32969e42f911e85f95cf14"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03e1748fb97c9ae1364038a440b604e5658afe80c47201e40cbf403456f0405"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f20830bcf94c0117e2b4b6125c90adbd1208c7f602f4c02d7246ee4ee71f0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4273258c20d92a9b4f0e710ec5e0d321b882408c2b2f5fb1792736bdbc5f8209"
    sha256 cellar: :any_skip_relocation, ventura:        "c88e9325102dbd453b5ba9286b7ad1b231dbe043bc507d627f7b970431f3db46"
    sha256 cellar: :any_skip_relocation, monterey:       "272b5f97d795303cee1de961a1dffd9c11777e64a5d6c7dcd81a92eccdcd21ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e94a46d0a4c7db689850e373956c49178bc9c52b33b06222ecef28ed581a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3445622b36b1210989e6f340c89c92ad38b0fde1694f81b5ddb5d16b691ace61"
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
