class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.4",
    revision: "8ff29c834ae3d61ea354109a36e3d483d9347435"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec71577b5ee2b55a6b1f151f77dff2fac46b7a3fec54efd3603554e06d3bd1f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d53697ae571c591b0b7f7ba84fa9e9d1b0ff7b654d21c75f2c414d39f4f51d67"
    sha256 cellar: :any_skip_relocation, monterey:       "970f449fb0947f1ecacd0e6b56add8650ae0f803d1fecf0f119d31e2443c948f"
    sha256 cellar: :any_skip_relocation, big_sur:        "979ccaa5caf932ceef8f3246399a7b835104490ddd57831c3dc5634f5a4d6302"
    sha256 cellar: :any_skip_relocation, catalina:       "b288a0ba8ce853c7133c0fb7c1f15fd14669d1db753d04ea4afddc31e555ef83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17129051da91ee6bdb9869d50ac62f438afaead5d388b63dcd06514518cd7711"
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
