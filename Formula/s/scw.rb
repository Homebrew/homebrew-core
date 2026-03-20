class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "85796afa87ef116bc190c02dabdbb126bde27f534aa8682ebee58acdb2c9e350"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd46ee05d698f557af3237553028203488bd2492578018744092c9fa7ac05d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed751fb8e817c1a14a60fc8eada6c6bb84955f684f147eec27b317e99f06c2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b50f4cd63b8ec2c8a83ca40b4810e269f0bf2457e2201b7ba04f9be2e332da"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4da171281908d21878a0604da133fea42ec402691a255aa84f793bc5f430e3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf848c58fabc0705b044acc6071ceeb41a8b6a63ff34da073769840e2477e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c342917523eaedcab998f29944c0ed3cdbed6c097a6e4e07cbc037ee3ba8ee6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
