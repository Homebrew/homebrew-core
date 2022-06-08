class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.2",
    revision: "68eadeb66296ec2b9d73dc83906b1ab89807d7d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd21a2cb4ff8f8e809f4dfb92a24508aa09db9cfc562d07519e6ab257cd6a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70aa616dc65db75abb2b1b1c9f981f08a66af6e69ad06ee7d97096c4e931465b"
    sha256 cellar: :any_skip_relocation, monterey:       "3b3f7eac4caf65df9b547f4fde646de8da6cce180c06e25d1250e7f6dc9a6c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "be098e60d8c8ea74fa3b4e0325a468e0e836687f8a580982fb39bb05e30b2229"
    sha256 cellar: :any_skip_relocation, catalina:       "ae570e29d3fdccefb6c9d6b0d36dce07f3dcb70921aaa830216d001d3c682951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2aa90cea7ac49b5da56e1f9836384b2d47960640ae69b1a1023750cb38c2d3"
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
