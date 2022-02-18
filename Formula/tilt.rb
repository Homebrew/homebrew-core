class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.25.1",
    revision: "b049a24a06329566757cae42408b54fc22c4e9c9"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bdf82ddf60165258a6c8cfa4ca818d439cd9bf9cb7e87e9bf9de660cdc2d2a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a59fa0804ab1a14cfd1f3238f7ccc2b4bc21f3d680824b6935e60cf65eb5a42f"
    sha256 cellar: :any_skip_relocation, monterey:       "e56bea2b2620d780c9fb38547002f71b13dedac1bbfb9b8d56c229bbbbdaeeca"
    sha256 cellar: :any_skip_relocation, big_sur:        "280d4274c35952ee11cdb546d32202810b75655f250e3b8415bcd75d7d40d442"
    sha256 cellar: :any_skip_relocation, catalina:       "c562e59a466481da0ba6bffa9d90da55aca83aa4b9bd180e44e67135cdc23513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f59a625e982558d3e8e178aa814c0fe467230883229e1edf46c84bbe72d52c1d"
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
