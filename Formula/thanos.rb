class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.28.1.tar.gz"
  sha256 "e00ae14b88b9a3ae6b1ae022a0bd4fad34fd2da401bcef401cefa5e087675783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3540abfe5d91f8eb51f2d3bc517a3d21bf0e9159b0da01ec09736e1e760d6fab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd370aa4c1ca1dc800ec746390eb31d7040326a3adaa2ad576062e666bfdfaf3"
    sha256 cellar: :any_skip_relocation, monterey:       "0923852314e8e6431bf4bd2a13b358f919dc3965c0576c383216fda1c6cd12af"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3a964a3f7042258d2151583e00c98cea1204d02a734c26606ad6083a1fe2115"
    sha256 cellar: :any_skip_relocation, catalina:       "c29937d2d9faef589ce2d66a6177a2d3c0053788bf43f6080416ca8a8e125351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13c86e100412b5233c0759cfca6f6df397d6d65d937032288d5e5ac60fc3326"
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
