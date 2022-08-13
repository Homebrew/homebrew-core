class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "4dfc6869ee125127741ae5182163698d7072450eb1c37f173895a22273bfcdaa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce563bf835a59c803af430125a1915b6b5d6da35aeb02ba589fbc3dea24ef3e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce563bf835a59c803af430125a1915b6b5d6da35aeb02ba589fbc3dea24ef3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f37495f511e06d203b35e60f99f35f1344feb42345e5a418cd73c95e180289c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f37495f511e06d203b35e60f99f35f1344feb42345e5a418cd73c95e180289c7"
    sha256 cellar: :any_skip_relocation, catalina:       "f37495f511e06d203b35e60f99f35f1344feb42345e5a418cd73c95e180289c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ff8aefb89cf39692d1908c5bb18735aa80a38a3a4dc7c312774915ea0bc42a"
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
