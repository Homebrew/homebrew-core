class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "cf84a0d79fc3ebe441ac234d482e5e620f38c50467b446d3cc3028d3d7b65022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7844e40cb685e5c50a069c6b35e3daddbfe758b9cb4927b23ba0899d4141014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7844e40cb685e5c50a069c6b35e3daddbfe758b9cb4927b23ba0899d4141014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7844e40cb685e5c50a069c6b35e3daddbfe758b9cb4927b23ba0899d4141014"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88279cc162975cbbe2e53e34aa1e6043c2b199c606cbc7c68cf49b82914bbb4"
    sha256 cellar: :any_skip_relocation, ventura:       "e88279cc162975cbbe2e53e34aa1e6043c2b199c606cbc7c68cf49b82914bbb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a64eb4d6ee52b5996f2925c9fc616ae73108dbf9f1657726b3490d7a63960233"
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
