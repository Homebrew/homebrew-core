class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.24.1",
    revision: "4b7b9bc2e659f4ea8ccff9fb8b7713618bffedb2"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70c1fce7b7a0ed35ebc6afe3481ba13431a47576453d4d9af8e0edc7305951ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5635c01e9358a4e885f94569ed5b911f00d382338642def982a0e5ee11fbb671"
    sha256 cellar: :any_skip_relocation, monterey:       "e3fe6ec81fd98e2607cf09d4d6385a970d9f6a483d1912641e2d3d188d38054a"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c16cde4b5ea28f5947ab3fd5d2e9eeee2ea865098c2a6642c69b94f3794849"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b5f76157703fb06aed4a962ce7d77a0987ec50c379fc1c482d52f2de0a54e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87aa4a0f1a1d51da5a235cba14ceddb3b7715e41a9aa323a1c04b926cf1d10b6"
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
