class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.23.1.tar.gz"
  sha256 "265bfda3f6b841489f3a75faeb5c981618f5d8eb91d25b9ec5cbe1642e78787c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "410ce2df71a62aaa2f4a34a3ffe25a2d06c2d8a98e91b9406e056d408f1edd71"
    sha256 cellar: :any_skip_relocation, big_sur:       "1460bb55e42e9b5d8709cb8805f1e514da2e220bbd1fa0bfc305fa4b36e33820"
    sha256 cellar: :any_skip_relocation, catalina:      "107000e5fb60d8bfd3dcb79dcaa072f46091ee7b1d6c0115a654a87f826b874f"
    sha256 cellar: :any_skip_relocation, mojave:        "47fc0cbd8a1201f5fe6b530d78189e381cd3a753f663f50f42df9be4543b7b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6403645726d149fb543fe0fcce54d9bf61d8cbf84c1331ced2f03c997f5108c"
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
