class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "9ed41b572f2e266fa30dd98981846bd78ddb455b3327ead073ca57a6e03f1c01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c795a634e36fbde867952adb95c70ac448906406c3eaff3f13e0cc437d517486"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3cfe5ea35cd8594b67a5c30ce57baf4b9a1a348c718e99275597a2153d6f607"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd5cd9a2575693afa9f533293fb936d14d40c33309e8d384203c254744a60c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71de547fd5c6ba31a2ff06a55c4d62c317eb9534e02a352828f848721a42db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6860994139c2c43bcae01d7fceb011608c6a5d25ecd3cb34c982ac27d2dfe608"
    sha256 cellar: :any,                 x86_64_linux:  "7094ec284576051dd0e83967cb8a49ce42fc579b5b0d00cacef416a73d9376f2"
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
