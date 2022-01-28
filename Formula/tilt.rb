class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.9",
    revision: "a7112ee78555429d1b26c882d1f318cf2c0eb205"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "990d9ea89ae14ac257a6d10e45667ae7b576a215a05f77ff7c9f86541c27799e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "727af67b4b1cd90c23f2eb842a8226c9adbf40da619733c7feb64ba71b31ea1b"
    sha256 cellar: :any_skip_relocation, monterey:       "75d5b119d1b3752739e88c80499290e87f1b1ca02e9e5ea3ebcc1db43974c0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c87c0f02a7471cdb181af89e17acfcfbbc2648eae93c085f4f58d91d32795e1"
    sha256 cellar: :any_skip_relocation, catalina:       "43d2849edfb8fbf388e97c95f56dc324f6bc253a824e6c4da1e9c8a6064e9493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1787da6c1bc2dba2ec6f2de7a52a1b93c7608377681233df25c3c81524213c"
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
