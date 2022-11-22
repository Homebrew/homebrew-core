class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.29.0.tar.gz"
  sha256 "45fa97935a8d4f426c677c6077e404cd863c16f758187ad16262451df3262a14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1df27161f056f75adc87fd2bf2e4c0ba276fc0c461dca2e6a4ecda456ea5495a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87189f69b99b0c9809b61717facf15934719d8db82732f7b7fecbc9ab232173a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99e46185231fae249a931bd781081cfb7d201774c63fafdad60af55d4cc1d8b9"
    sha256 cellar: :any_skip_relocation, ventura:        "ecbc1d74b3400570bceee66ad1df9ff9bbf7a83661270bbcdcfdc609d97dfd00"
    sha256 cellar: :any_skip_relocation, monterey:       "88847c74c7200e7c6a7c2f64416558df94e14d6d6a3a1ad6199d49cfc27186bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d517c42bf13aeda4001d6624850d3ad91d48175124f2159f612966d4da8bb46b"
    sha256 cellar: :any_skip_relocation, catalina:       "55926a2b792a0ec2bdfd51ce2032fa714d3a7544fb36deba86baa263795aff33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f333fd049559a17952e3c7bd40c98d65917968081acff4063b4935272eb076ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
