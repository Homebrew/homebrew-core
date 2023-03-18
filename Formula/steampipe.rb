class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "2adbbf7142f2e785c2671db577f9da49e549791cd9b6d15dad0e9d3bce5329cd"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac45388b249241acbc1ad625ace1c2385f39fba3815b256251fa5ad95631a471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149d42482fef02ea9aee166bdd1d3aaa4e27396057208d2bbffddc396ed1570c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146f7e75ae4e2ea1118fd601b0480bb6bd6b96ff5bdfe9a88f013458553abf7f"
    sha256 cellar: :any_skip_relocation, ventura:        "3c1e1331874317a8b00a1a4b5df686081365fe463a34ba55d682732684b1969f"
    sha256 cellar: :any_skip_relocation, monterey:       "f217188a193a9ae14e874fcc21e9f67e42f3a29f074727c76ef7b1fa569675f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "633ae2db2b968fdddc008de823d976bd8c9c48348506f7fd57aa4a2aedc440cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dffeb5fa59659e69424da67988f0ea64a8b2639208c9de78ed31c61566d11c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
