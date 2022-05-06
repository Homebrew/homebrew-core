class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.29.0",
    revision: "77d984c3d419587e59ae24a16812e2fce553f6fa"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92bc11cfb09ab55db876a9db5d5d99bf402a4ea6472c3947f2f8e14a034690a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ece6faa85c2640b02c3754b88d73d526f4345a1103bd0e312fa900d645369c9"
    sha256 cellar: :any_skip_relocation, monterey:       "6758be956f6a22a0736bb43fffff9c3f62459b32a4181287d56b40f1ef5badcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3069dac145913494435f86f17d47a5ae9a5acf5e088179d6b2dada969de905d"
    sha256 cellar: :any_skip_relocation, catalina:       "0404de27fdcab158c1299cc84551759472030a6e56f257a98ef1e101e042e26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96aaea9af9421956a0b47423b2c579e39bbbda7691d771cf02636eb625ca5ee9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "bash")
    (bash_completion/"tilt").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "zsh")
    (zsh_completion/"_tilt").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/tilt", "completion", "fish")
    (fish_completion/"tilt.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
