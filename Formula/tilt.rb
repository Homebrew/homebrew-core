class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.30.0",
    revision: "e33830b0a517386437902d3aa3f7a2c72504aaf5"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc3580d7a9b9ccda581808bbd85f5a0b79e1d947aeb8ee632348efc31aa34f9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d05819022c4dbb69590bd6181ab8b13db1eccdb29a333ac2238094f05441dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "f62c3b4155049964c932b1970b829682f42f5f20e275559fb596199d7cb37ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba8e55c76b7b672f499976f8c8662f947ea7fc0459f485316064f9517bcc6278"
    sha256 cellar: :any_skip_relocation, catalina:       "fe6c9e616974281a6f94f01609c31c24b7411b82a18cfa00b3163d12c26f772d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02fcd25d9996d9c93abaa3aea9db76c763d08015eb7ba3829937ad21841757e0"
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
