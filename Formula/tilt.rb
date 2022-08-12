class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.7",
    revision: "b37791ee704ee45a9cdcd7f4fd74b8dcb03b2da8"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5340849afdd7c560e0b0ea35035e2a30b923d03d69ab488a8c7bde91bf8c0d6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b72bca256d65aaa20e968ddccc0c3c34e1d0213639a80314aec72df910613d36"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa8abcf769697509d48afc7e85e89bb483310f7784779d88e057eeef32be20e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ace33a09e0f1692409a053bac17b8c94473056385b2cf98c10b0f3e4ff8b2ec"
    sha256 cellar: :any_skip_relocation, catalina:       "63be918c335c266c8bbac7659fab278058fe7d93d4ede21416bb8fd14cf6463b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5806a94291f17fc2f5761a16ef19a6496d6adaeabdca57a0fd456b9cd0a6266"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "make", "build-js"

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
