class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.27.0",
    revision: "2d28fac9d99015bf2ba1c87cd09eefe40ccb9019"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9a407177f31dc8504ea3a2eb4dfd6430b47198fc5a5d69a30f430b34ff9c3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13b9a434a24e907ee557ef5e291362359872e992cb4521290d4686f3d8e464d3"
    sha256 cellar: :any_skip_relocation, monterey:       "fab8a5b2eeefdf2d40b513865b7f1316446ecb0c5d9d66f18b85f1421d90bd4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "83d8781d5fc0ffd661a7aab566b56e12b64b65693d80dbb676108ec09fd4d9b6"
    sha256 cellar: :any_skip_relocation, catalina:       "ae6ac8008c510e59c7218d78ba7e23c4d9383f8918c31f4a7afa5be3b8967586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe3c564be55fa35d2ef90b613bf5cd9ce90c8531816e3feb4602d9299fb457b"
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
