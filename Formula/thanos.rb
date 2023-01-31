class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.30.2.tar.gz"
  sha256 "0d76a51925b35737716ca41fc08699dadea1fd5feb9effbafa4e001205e7ccf9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9627948031683b1f417a970aed9be0265de283fa2b75835a6f7737a9e57fb5a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce04130aa19a7244eb9fc0a6a03932e1783ae9268555f43b589823efff01f2e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24e1c8b7f2d63c5d995e6b557d3a502c14caa4e9950844182d15fee62df286bd"
    sha256 cellar: :any_skip_relocation, ventura:        "9da8a3375ebe7bfa7569a2ed418170f32c0d36eb6e4848ca712814cddec17549"
    sha256 cellar: :any_skip_relocation, monterey:       "8839197bc0eab7f723afe7397c3f8d3f10f01a2d3c3f40b58a8ff5f6ce0a2964"
    sha256 cellar: :any_skip_relocation, big_sur:        "a04558e2fa71246adaaf0791684fbac6fe4966b7b1d340a11f902a09a3f2ee5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be442d665ceecd7cc32a8344129f317a6291791ceb901bf05da5ba8ce4a4df0"
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
