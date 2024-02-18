class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://roadrunner.dev/"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v2023.3.11.tar.gz"
  sha256 "18fd9aa11413390e4e1a854ec2ad4bec788572105a7d3aa1ff6201f9e461529d"
  license "MIT"
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "015a241cf0005eafd1a418bfb45d05dbad5540338bed3f9f1de20f55e8a46fb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1331a6d48ac1ca6d5ef7f489936e3f825eef9762cf2b1ab950fc021d8b0d0b92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5f96b75befc0b369589dd2d4dce65719fd804feeb1d850909149086a94484c"
    sha256 cellar: :any_skip_relocation, sonoma:         "522c1e62cf79fb7d5f65188f2797abb702bbea4d0730f5c28f363c481b28fb92"
    sha256 cellar: :any_skip_relocation, ventura:        "9446b5ddfac3bf206cfe04ac16fbb8c2449c8781653a9a9e76655ee55f0dead0"
    sha256 cellar: :any_skip_relocation, monterey:       "2556ee9117addf487b62b51d875cbc203195d9b16a63ffa139ecbb077b02a775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea84ba5aaa9b42f0681be5bad1254109b40fdadbce1fc9f117558a5fe529b1ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v2023/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin/"rr", ldflags: ldflags), "./cmd/rr"

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
