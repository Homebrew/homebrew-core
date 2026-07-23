class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "18df15433bd097e80a9383e6b631ff77fb8a248655435af0cf3da59a15683996"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91875ab3b482781ccf98be0d05674382f5773f6d704faa349b3a36b1d3122907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7678b09f51dfde7811ab36919d4cdc7e287d81637875498180e797ce4c4c9b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b57d4ebf82afc017d6b6458a79b4a4681ec3b58a6f39ad58f21b2bb54f414312"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a12ee51c07e300993d3d4ae58c8ac73563b555dbcec3d6b774b381b2bfb951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58b5a671a97649acfa3bca6ec02ab7b1de2fe4e3b2d16a55c9eb3b885bb786c6"
    sha256 cellar: :any,                 x86_64_linux:  "663c0f3385bbd8f2b2fdb4b7bbf06424621d7af00b01ff8782f99172a358b246"
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
