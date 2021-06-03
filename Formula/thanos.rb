class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.21.0.tar.gz"
  sha256 "523b828efc8a8343e1ffa083b7a3f1bb7ed518d262834dd6bd559775d01eef6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a28e31dae92966e0d0e87c4ff4aea1ac9f0e8a202ca722138448ca8a3abb7be"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1187c61fcfefa4e066cbd05d2ccb0ee67137c86eb9302dfdfe3d9c8969e726d"
    sha256 cellar: :any_skip_relocation, catalina:      "ee93654b10490c333bb660490bf3c2ae23a58a1046e8aa4b9e24027ad7e588d5"
    sha256 cellar: :any_skip_relocation, mojave:        "915242f01b40da9d7fe22fbc338099c3c3de6158b993f5fd4114b6f37477f604"
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
