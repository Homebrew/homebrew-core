class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.6",
    revision: "cf684e2890d199aad3812ade8daf4f2cad83eef1"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfac14194163ab9bb13ccfe567cba120ceb1c6e075c4c75da691c9a9efd8c6d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ee5d96b7ca179c26846b99680015206891fea1ee1ea4417feb9aebe7077cbc1"
    sha256 cellar: :any_skip_relocation, monterey:       "90f3616ae02605766b9b452615f87126377df8b31f1763fc70b7154306b87fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6170bb2d4e9685673461fe6d19090ddbab63c06a8aa6d2089b093ba1b4761c34"
    sha256 cellar: :any_skip_relocation, catalina:       "c4574d834ad6a6e614184c6b60b1cbe78401723f11d6220ef2164e528eafba99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25fb32169bf79a42c7ec3c26f9079e8e5470890b1a94f3c4adc1cb24064655a6"
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
