class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "9e68d54d9280b30bf05bdb8bedab8c8f594d9a0d3a4cacd02ee4d88aaf3e46d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f85cbfc858900e45eafb527ae30a1418c2bcaf98f26a7041bc19a3f60a48139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f85cbfc858900e45eafb527ae30a1418c2bcaf98f26a7041bc19a3f60a48139"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f85cbfc858900e45eafb527ae30a1418c2bcaf98f26a7041bc19a3f60a48139"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9bfe6c70a2b0b6c9427a3c3ecfd6660c14ad78df74175488d1b594aa2a6a924"
    sha256 cellar: :any_skip_relocation, ventura:       "d9bfe6c70a2b0b6c9427a3c3ecfd6660c14ad78df74175488d1b594aa2a6a924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2344697ec1250d44be432cf219659dd29217950c6805f2238dd7881dd776158f"
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
