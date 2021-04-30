class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.20.1.tar.gz"
  sha256 "e3821568e5d36ba1d0206eded8e9ddaf9950dda2032c1e122e4fba340c9efa7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1a207706cdacacb3e428c8ea1af5739a8d12bba3898e4df94e3d34c8250cd36"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f69fdf0ea0124baa7a4a77b0f8e0895a2b81a997b02310ff5ccef87e919a143"
    sha256 cellar: :any_skip_relocation, catalina:      "daf51b90e9db015ffa8e75d24398be7e010919e6cdcee2068de2f67a18647fef"
    sha256 cellar: :any_skip_relocation, mojave:        "f329991480819f9cfcc6886d79b28734c036aedd4726724b667a7dd7edcc49cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
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
