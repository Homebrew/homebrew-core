class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.6.2.tar.gz"
  sha256 "36fd7fe643f0848ec6a89eab19e6fb9bf3303129dca4ce99c7c63de8bbf0cdd4"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95760723523b5b3a8768126adc0b06533c46e8b2985fe1c6d17358e73124928d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95760723523b5b3a8768126adc0b06533c46e8b2985fe1c6d17358e73124928d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95760723523b5b3a8768126adc0b06533c46e8b2985fe1c6d17358e73124928d"
    sha256 cellar: :any_skip_relocation, ventura:        "db3079d62f983cae963d6b1e27e57ad3cc2960ec534a1719f48a9686848dbcf2"
    sha256 cellar: :any_skip_relocation, monterey:       "db3079d62f983cae963d6b1e27e57ad3cc2960ec534a1719f48a9686848dbcf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "db3079d62f983cae963d6b1e27e57ad3cc2960ec534a1719f48a9686848dbcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f43ea972dc8f5ec11604025efd92a7c819b3114345ba0c0c3736a23cb11535d"
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
