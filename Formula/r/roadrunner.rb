class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.2.1.tar.gz"
  sha256 "42af64a92eafbff58e8f684fb50a721be9f5668e38b44171c776563e1bd399f8"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08924e7b00d8923422d8b4d48fb84d3435bafebf09c67f906523d1c0dbcb196e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcee57443a23ccf96d48f2d5892b0ff193859387a3ad79bd6080a80507c29f1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54e890c7644a4ac4d021af843a3d4ec74b3add903f7091e865c6052c9c7406de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b101b5b8a875fe2150d8fef5bfd8d22823b287aa735c3a8cee75d8e9fe45c746"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f2ad24d0b2fd0a1c3ac7586b54ae2df2b258663d7777eb38d8203471e8191dd"
    sha256 cellar: :any_skip_relocation, ventura:        "01c76bc92d913fe3dd9c06717c977d842f14839f253253bc5c43c7d37fdd979c"
    sha256 cellar: :any_skip_relocation, monterey:       "90e46a1414169f2d1c706f28a56e468cee183f3e20ee3cad59a65f83949cfe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec82d2b0f90e54acbb7c6a78d86e7273cb361cea6a1b1ef18b7d78b6291036b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", "completion")
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
