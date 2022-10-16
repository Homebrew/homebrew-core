class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.4.tar.gz"
  sha256 "d02fde9cb8080bcda8c59640333c5b7e4e3700071c52708b805f0bd981992488"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dcb201560bae839ddc86d205518181cd4978757658fbfd35f48f7cc83137d40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8509a483b499e04b66f3b8021b90eeee0bbafae374bfeabf3bbc1e7383a536f8"
    sha256 cellar: :any_skip_relocation, monterey:       "d99ffc1873733d96be52c661c2f8d22165f4999b49dfbb2d367c03b0afb876d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "408c34b1b4bd9d4e2be358695cc664712022b8df36568ae8329ebf88d5e99355"
    sha256 cellar: :any_skip_relocation, catalina:       "6fdf5423fca605a127a1f132ca4bd33c13786aaf1ad4affc8d3b5e8ee835f8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99c1e4f1e12fd3e246284d6fb074304dd0046e8019494f4952e1d70fd1990934"
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
