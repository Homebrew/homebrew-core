class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.22.0.tar.gz"
  sha256 "dd3b86719efee738402c6b9ce0686055447ae9ab5ce9a64c3a357c914c651073"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2880c66594b2c4932fdba9d90b6ce301b94efa44d86b2e8fee3dad1f4cc4797a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cccad8e8adad38d8369aaae9f1df6ee11caa88a478b45d415d3980774cd3a45"
    sha256 cellar: :any_skip_relocation, catalina:      "16e895b9bfee9ab77b11bc0d3637088dd1e0e72e127b3aa3a45aa34ff6f31f1c"
    sha256 cellar: :any_skip_relocation, mojave:        "0cae3c6b0145d195576eec2d90540d894a495fe990eadb177dfac760aaa61f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440d556924f3826b62f0f5a4814a5b52cbf3b9c22ec5eb0b423007e61a23cb67"
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
