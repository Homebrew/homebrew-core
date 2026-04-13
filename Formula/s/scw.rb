class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "ae7c0fa5512dfc0ccb9ad7223cc6a92bae40df1a4d58ed6816097715e7759a9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b843f3d982444b3f65674513267722546ec38fb101c466e558703d4f7feed225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b831f530a182191db742157a5edcb5c7ad1662dbbaa5e98842710bc8755b2883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6aee4d5a30ca8700d4584a5d052b747dc47201124691a0b47347b8a520fd5ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e64fe4581ba72579942bd15a1b29f213f68efc9dbc16cd18777a0b2f3eb028bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3795e7d1c4c05b566fa767be1396beb9f3fc229b55de985b448265a8392946d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f901beed38461bc77e10e456a0aa54c1ca6a112bb8a94b71db5059f1cfbbdbfa"
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
