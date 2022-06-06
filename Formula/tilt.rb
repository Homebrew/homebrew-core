class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.2",
    revision: "68eadeb66296ec2b9d73dc83906b1ab89807d7d0"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09dd479bd53ae5344b63291493d7d44573f237231860ebeb598ba6c8c6eddf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f39bcd8e436ecdf028ce94ec8e08a3c3c5e4f3cbac2f349cad2e84898223553e"
    sha256 cellar: :any_skip_relocation, monterey:       "edb8cc288e173085221a2c63012187af24d54eb8430fc2c962e6329be73fdab1"
    sha256 cellar: :any_skip_relocation, big_sur:        "17394bf861443bb2250cd82822dfc57ba5d5a03a93e84f1e7e4e4b9076e1d7f4"
    sha256 cellar: :any_skip_relocation, catalina:       "672742c88ae41f4752ed68a247dbb69983e164b26d8703d51c80dcea67d99cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0911f3818de3e770af2f58af71d5a441a2afecbe3b3914ae48d323bf8357dc0"
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
