class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.21.0.tar.gz"
  sha256 "523b828efc8a8343e1ffa083b7a3f1bb7ed518d262834dd6bd559775d01eef6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1250ceeebc64a85f8ee7b0a4c38857c0b9993267bc7feeb317b89eacb587e20"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7697fed6910db472ebd0096ff5a1c4e71dc70e21681739fad658aef208d4853"
    sha256 cellar: :any_skip_relocation, catalina:      "80bc1f564d6bfcecb2751888140908a5c244e33bc2e3093981c1fc2603b01cac"
    sha256 cellar: :any_skip_relocation, mojave:        "a505553618d60e2e39137ab508e0eb39b6ad544f4518e55c8cc01aae789c2585"
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
