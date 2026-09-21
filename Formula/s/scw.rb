class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.62.0.tar.gz"
  sha256 "055c5c99ac022fdb1d7c235928bd9a331ec04926ba00241b93cbb4c9ff8a5583"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bab3219563b602fbf1b5f87b16e6387d61ec8daa4b78d727100fc1a5a9260419"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c608535d000489f1d36885d88dedd6dc502966d6d8896d258a7eae3dc41cb53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73dfaeeb9b8c943fcbb63cfdfaf3d07eda286e8a13b7e83cc542fcc3b0bef756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "493c19b34a6578de301c25634dce19f8a2a77b300a350864f80f4d9c2fb2b7f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "895cff554aa65a1c3038e7c3cd3715c36ec0a23ddfe56ba8cd23f3f4ea5ca157"
    sha256 cellar: :any,                 x86_64_linux:      "c1916cf30df5162a48fbeb5b4a83d4baa26db9f2d126845db46476f2f2da8645"
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
