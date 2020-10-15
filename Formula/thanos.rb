class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.15.0.tar.gz"
  sha256 "f64321e0e8f7f9a485956dadabf11c305dc4a1a5f40693fbeb5aea8b5862faad"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a70056641e1886b19b0478061f1771822f4201fdd96e06c7953b7842f3c1e83" => :catalina
    sha256 "e4de7bdda7f6d433c32bbb00ffbba10d94a3870303b7165afd625f35f71062b9" => :mojave
    sha256 "7425526c2c895f489da382413c7abadc89628a22e030f40b01b0f00e719ef13c" => :high_sierra
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
