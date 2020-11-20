class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.17.0.tar.gz"
  sha256 "36c2bbe5f96d0032d7bdfb535132ed78652e4a16cb0b29711f0a7ad63f468ed3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9fe4157a02dcc91fb0638cec6be28a78af4e3779817fd74fb74bf4d62bc4f4c" => :big_sur
    sha256 "dd89991f38fa7e2cc7c661de542bf6a5697b0e0c4b8701691343d2bcad24be9d" => :catalina
    sha256 "20e77c4ffed4909e6babe675fe37e438030f00e1aed7c9c6da106b2eb67c6ffd" => :mojave
    sha256 "b0b5a6b64913304a900d77898a31d728e0d795eb5a2814259cd3d7dc54528edc" => :high_sierra
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
