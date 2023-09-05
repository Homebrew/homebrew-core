class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "8f01210cb0367f337ed005455e75c7c90474432219b90bbd6dc5569fd14b2e63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a369e64e233caddd364b4e167babb2d3870803c0d3974f33c1499a094422480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d3470910ba8e132e4b308d16c13edb946029877b929f9dbc3086a01c5396c5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfa174763911c37cce5b076753a51a06e113e957ed837109bd66b6b5d166bbc1"
    sha256 cellar: :any_skip_relocation, ventura:        "e2145e625700dff793c1b3ccac32f6c06790bbcab43298d7fe3aa1c286ddb49d"
    sha256 cellar: :any_skip_relocation, monterey:       "a1844f87dc1719af9f3f5fa780b4f2ae82ca58707a4c61cafd1a2acfe510949b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b252dcd43dcf8fa206a90640b2a5dde54a9d97b3018a230aa3abb98291680a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b01ccdf03055d2e322471b03e923bd4a4387dfee8272916d0bbc139cb93ebed"
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
