class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.2",
    revision: "68eadeb66296ec2b9d73dc83906b1ab89807d7d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9f52aac48cdb24a069a3911399f07ee018b9c525d512792b936ed3ed2ddc42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1fc94914fac6306c2fb41b7047f1a69d9c4764684533c1fbeb1c2218ac04416"
    sha256 cellar: :any_skip_relocation, monterey:       "abacc511994cc336cd1083011e1589a0658a77db0b5a7f1f1f722eae4131072f"
    sha256 cellar: :any_skip_relocation, big_sur:        "39a926cdb54f0c2b0c9f8874f8b6b51802aa831b82e9a911e96a8f1f66c555ba"
    sha256 cellar: :any_skip_relocation, catalina:       "b6a8d53af0af50384641fb20c31ff0a42b34e32caff90ce57ac9011e3f6f327c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20a32371b72ba428a8dba01564c898b9bc50221db7a5dada59f40d4180895b67"
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
