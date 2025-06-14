class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "b9601d38edf0193f63de4794971f690e18234a0c83d42f1526d90fffd523681f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb5abac55895b2f70e864b69803d6ff9d5d7fbc646ff6d57e39ea57d779869d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb5abac55895b2f70e864b69803d6ff9d5d7fbc646ff6d57e39ea57d779869d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb5abac55895b2f70e864b69803d6ff9d5d7fbc646ff6d57e39ea57d779869d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c698b87b9f3684b02b39556270b83b197a4ebf8d29a9f4f0bb17501aab9d332"
    sha256 cellar: :any_skip_relocation, ventura:       "2c698b87b9f3684b02b39556270b83b197a4ebf8d29a9f4f0bb17501aab9d332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751e7e38296d08b8dac202137727096f52c242ed569f950b12c2185a83b4e377"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
