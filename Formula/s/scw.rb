class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.65.1.tar.gz"
  sha256 "051700be1322e38aa6fb01330e945dc2d538912ed8647a2ea197dfc5c2b50fe4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fcf72e2d637f66858a28ef2f4a9a239a808316ef491d9bc03a11b0bb52d2207"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83f28bb8837e6094791c56768ca0edaf568da4a6d713980449dce91444214f64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4fe8af24e350f8b1545205d06f01337838670b976867f39d592d2c164ef14d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16db655f4e1bcb31b2f772b2f9b77f9aed3cccaf6e8a3ad8deeae95c5ffe9fe1"
    sha256 cellar: :any,                 x86_64_linux:      "8aeceec97a04e6e01ff639ae87b36f7283d3e068f9fae8e4165a7977ece08f5b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
