class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.7.tar.gz"
  sha256 "6ff2b05189727ab3bd8e3391b7c5c9c4ae2079a81e766f509fe21033c435134d"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f6331fddb5c7e5ebe1fdebccd7c3e6eb0d8ce86314cd12b71097348edf05a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6331fddb5c7e5ebe1fdebccd7c3e6eb0d8ce86314cd12b71097348edf05a1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f6331fddb5c7e5ebe1fdebccd7c3e6eb0d8ce86314cd12b71097348edf05a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "53f02ad9b52e008b0ca574247091c39caa8dde066ada16bea198a0e1b506d6d6"
    sha256 cellar: :any_skip_relocation, monterey:       "53f02ad9b52e008b0ca574247091c39caa8dde066ada16bea198a0e1b506d6d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "53f02ad9b52e008b0ca574247091c39caa8dde066ada16bea198a0e1b506d6d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bbbcfe9d0bd7aa741da307f8472081f3efc74af5a76adc5bae6834325e1250"
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
