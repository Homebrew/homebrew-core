class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "f0bafb8b4715ae012c671305f60e3128763963fe31d0dd50c3fb602f3327e586"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f89ad589d2beeecc7160693c7e267fe1bf3b97f36c5b3b0c657f14b3406cd9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b09465ae7f6b1f7cc1db74f7e7aa1dc73301f5e3dda7a0c5b5c47002c201c55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2fc6714394d9c7cd22382885d10a033a8af13cf52b92ee652caf63be98e76d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "becc951cf84ac0db8a58cd80a63f70c501baf697930ec350bed16e9656808057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c287a041229de084d5839413d3816cf71ee7b402f57f05594a15e11a6fc0fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7a8c387d3a90d7f0ac3182571dd25511fcdafe3b220e92b84194e2313f97d6"
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
