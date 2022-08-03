class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "76700c2b8327f1228a7b1cfa5238c1739de029bd20caf3b10c264e3e00239387"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4fa8e05f74aa696ee22ef23635a7830851faa96ac939faff170a5fe933cafe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4fa8e05f74aa696ee22ef23635a7830851faa96ac939faff170a5fe933cafe"
    sha256 cellar: :any_skip_relocation, monterey:       "c013e74fcd18bf49f7b6c2df73c6c103239dfe0fd2bc690fd329b06a95684d4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c013e74fcd18bf49f7b6c2df73c6c103239dfe0fd2bc690fd329b06a95684d4f"
    sha256 cellar: :any_skip_relocation, catalina:       "c013e74fcd18bf49f7b6c2df73c6c103239dfe0fd2bc690fd329b06a95684d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f82ce3fe592056a356c7ce02806fd4ed8666b4ea78fa876079bf492ab4e1bf4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
