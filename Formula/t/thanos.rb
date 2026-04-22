class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "7566a654e7ed07f0aed194c4c2fee1f60bddfda0bd8d7458ce735ce2e868ffc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af0661c2a78ef3e92faa2fe71e88020af6e5feb8125dd5bd01de714e9960e120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c7da513ac84acfd289615cfad300e3d00ec416ead9bf33ec6a3487e16dc35f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2697f75f98288dd410c434ebb30e879b1e57d4bb56df6da1ee6b029ca931427c"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ad9c6fc6be25934665460fc45f041388c796d20b190dac187b200a6960ac03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c8fc644d15d5c0f9bd3ca3037dad7010787db8eff7c24d9d0b5ffb46bf1adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f83788c0f27c6634052f2b5bf524510cbecae556d8136b808b2cf1660daf075"
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
