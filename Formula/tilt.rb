class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.5",
    revision: "137b40f47c85bb599a2633a8dce4babbcbe84f90"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0909994f22c45ec8cbbe3c8c106cd03dc140c0b23afa141e7d901775389dbded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7d558941a4a9fac8eeb5f33b76cad8b0f20a870d52ef564f91dc99150764e5b"
    sha256 cellar: :any_skip_relocation, monterey:       "74cc6ac6fed3a1a5d16cdf395db92f0b6c5a5d04b58fd685f3a13f542c4df7d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7334283929890e7d2f4e7620cb3eaf85fe7c48051138e81b81f6528894a2bb20"
    sha256 cellar: :any_skip_relocation, catalina:       "ce33ff42452bc60ec54c74a02e93d2b0dbaac34dc2c4e7ab364ecad625275dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de91bec3970fb372a72e53174b97318e608e98925e2d3fa54f5891f549250fd5"
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
