class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.27.3",
    revision: "52e5ccaf646c79a0234ca9f0e031331f3a470438"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f96585f98c03060ff3fe1242ba4987b93f7b6397a571c01371ceb45a67a26d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d45c3a0817c617f879847f3ad91b295209a306b8be9c19b783f515cb9e1711f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb3fe1398739982e34b81af5c7f013bc17485a6b214c9735ab0e50786ff94bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff25a7cbc088c6981e3babc50d3ed8d2ac822e1e922e8ddd8ed02108a1e848eb"
    sha256 cellar: :any_skip_relocation, catalina:       "6cb80834cfbfa13628b29cdbff9185cf57093ea3e6979a338d5482e80d32edee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28796489a3ec4d8804886e451a1f711820d49d6f890893f8ca7077577ef4aa22"
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
