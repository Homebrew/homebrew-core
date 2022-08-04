class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "2730f8b17c27d1b98d0a65a152a9024be384cd0787cbc621bef7593950928430"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4da9665b43f77c74aa74027d802350d67f8b106c59f55773d9d6413789381de6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4da9665b43f77c74aa74027d802350d67f8b106c59f55773d9d6413789381de6"
    sha256 cellar: :any_skip_relocation, monterey:       "fd75cba30e79647ced0d8993e4d21bb95abf6be0ac2285e8b3fc9476b5ce2947"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd75cba30e79647ced0d8993e4d21bb95abf6be0ac2285e8b3fc9476b5ce2947"
    sha256 cellar: :any_skip_relocation, catalina:       "fd75cba30e79647ced0d8993e4d21bb95abf6be0ac2285e8b3fc9476b5ce2947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c85ca98fdd90b1e8db7d876499f6d2accce9159f7f18ac4351e2e2005a264921"
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
