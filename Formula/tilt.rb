class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.28.0",
    revision: "5eeca6cb18044288dfe7662a62e6de49e59ffcc4"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "519fdefe32e70ac78dc8479ab42a94ca35bb0ce70e7b2ab7bdc5d15462ce9ec9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "674e2a7ed979c58faea4d1cc8e16387f61badcbad6c685dd88d6fa08fef615d8"
    sha256 cellar: :any_skip_relocation, monterey:       "774d66e47f0670b55202f61db699502abc17d996b0ad84b98d237a50af64ea88"
    sha256 cellar: :any_skip_relocation, big_sur:        "df79ebac782d08d4c5face9ed93fb4d1b97e1a2917e272db94187f1fbc8c4628"
    sha256 cellar: :any_skip_relocation, catalina:       "affe559cc314edc139815fcc390a2be440aeb91ad2ada5a38f79dbb1ec4ec048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbbe184f05a2f623e955a52c1ed15325130e9bb822437927c90bc91648596db"
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
