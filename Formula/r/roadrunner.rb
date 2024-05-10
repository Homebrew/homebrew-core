class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2024.1.1.tar.gz"
  sha256 "2355b240750549fea2c182dc1e637f60c70ec9de23e4d066f8e5b3d0ad62c5ed"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e02a375ed284323a410c73be2620d6096d031d3164212e8b1019b95b22c6ca0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c05ce4c262bce4279160e29da7ec172db263782b076cb7f8327fddbadf9cc88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "326b0de7dc429f5eb67407b21ae4e6d37d998845788ea3c547f13319a3fb13fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f481fb1782113ee66a475688cf1f827bcdb46c69b10b7b128f1fce3605b25aa0"
    sha256 cellar: :any_skip_relocation, ventura:        "1e8a48932870ab05cc937ae990745e12d803cb5d1b8a6fa95dc5145c33b21c58"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c7b6c5ae841fe4691eea2e2f0415950aef4803616759b7e4d21134d5e37f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acaef2eb6870a818fc789a73dbd1c55395493d83027303c290fc5207b00613d"
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
