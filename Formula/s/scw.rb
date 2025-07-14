class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "ba056eacd5a012a55789421d0d7579ee002ae298ca9a04a1d9a88eefb0d13ae7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c15047638fd6749cc5e8d963ed170df70012251fedda3f45f0fc8d7fcab2170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c15047638fd6749cc5e8d963ed170df70012251fedda3f45f0fc8d7fcab2170"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c15047638fd6749cc5e8d963ed170df70012251fedda3f45f0fc8d7fcab2170"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b7cc0a2ded7fa8a0d9eaf996e8c9bbdabc3beddfb14b7d4658315eef06b702"
    sha256 cellar: :any_skip_relocation, ventura:       "99b7cc0a2ded7fa8a0d9eaf996e8c9bbdabc3beddfb14b7d4658315eef06b702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb18f1190ab194a51b6c57790844e6dc81ac621bee4e24fd11c4b0c358c052c"
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
