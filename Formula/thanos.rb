class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.18.0.tar.gz"
  sha256 "7fde764a9195293e8eca6bc89491f2d60e035702a265462c6e2d75b6c7e9983d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b53cef76e7288c976e81251378d8d55ba6bedb3fbd57c2f6955a7c0abe57d67"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ecb2fa083f8ad520f89d2424ffb65a29e669af6becc686242490cddc74e2e3d"
    sha256 cellar: :any_skip_relocation, catalina:      "50d4f18119c24df3cfe0817e8ed3423eb7ca0b773dcc97edd66c228fdddc0486"
    sha256 cellar: :any_skip_relocation, mojave:        "340c64e9f180c614c6e91197e8c111ba0dc1d1689af2f95d34684bcdab29d199"
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
