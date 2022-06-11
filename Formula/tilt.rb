class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.3",
    revision: "400a2fa1a4acf795d76e5c3e68a91c152049b3bf"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cd725343791ad727a083272479fed997f1aaf9e7fcf121b3ebfe21d4582b2ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71dfd7333be98104972d039423386b79ad45ae4889dcf931b1bf8b9226b11ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "921debd6dd2e1b6dcabbfd1e9ed2dc4611e16f77a90cff49a7dfaa0e80baaf35"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c3085d27aaa3934236483a4f422559cf89f29daefaa64757038122e9b2fd44"
    sha256 cellar: :any_skip_relocation, catalina:       "8ca474eb3146b0f9a013e88fe040f0f80f644c6f4539573957c65aec31a640f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87df185dd690ad8a575ce2beb36ca79e03cf9b0f1979bcbdd5fadd3355eed5f"
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
