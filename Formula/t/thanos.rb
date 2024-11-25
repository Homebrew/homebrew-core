class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "f68968211bcdab261d2e19093cae238c4a568b70f1ad2104e37cbcaea7a64e03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c4bf1de5c06c0a71585f5e9165b55d71d73d79e7c52342a10d253b9955aa689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b78a0d0b488443e76f0c4507ddaf8c468afce338266619b1536bb645ca228ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "654d1b7c771cdf49ca1fe2683efc4c37a9a196bc149d3e23299215f79fd7bfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "782e793d240772d036883af66e6cdbfad5e3a8f9a30c280712c41bc64f91d8c2"
    sha256 cellar: :any_skip_relocation, ventura:       "8bc1daf274c8f60607b957d8c4dd5d8a8d85c39330928ac7b57d56538bbf91a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b84bae9619c0a1847ecac3d7cee49991c894e2cd610037087dc8bb44f5d6fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
