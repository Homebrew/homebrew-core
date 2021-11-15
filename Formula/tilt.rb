class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.23.0",
    revision: "d3ebf7fb553a58f7ba90afb969c49b9c029e9fe6"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e0bce5e0f46980846590824490268aaa549112e84b259e2114e01887f6c5db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ddf7f2a96d0a99c9bf8dc691674f546916498321a7956d7282c8e36e31ce6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "8b4f851ad600ee5f30f32ede12421f0f22282aa18a4f7a5cd852668019b492e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1ac17cae310e49652ff88abf43a162cb49873efd29b94a67508c841d63d559"
    sha256 cellar: :any_skip_relocation, catalina:       "037dc69741c7bd31ede71cb1e286cd26032aad74125178de320b383dccdb8e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf9e3e7114a739ba86ff24e1fb341bcd9d19c698f17037c102addd0d629f704"
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
