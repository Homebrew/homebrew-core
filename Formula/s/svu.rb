class Svu < Formula
  desc "Semantic version utility"
  homepage "https://github.com/caarlos0/svu"
  url "https://github.com/caarlos0/svu/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "64d81d3ad15c44deb872be9325e090ee545bed73b12e663b23ef7405e7ef4aeb"
  license "MIT"
  head "https://github.com/caarlos0/svu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d58781f22d5f5fe1165fdb06487ed9961be753ac2f59a65acdba206571b596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5d58781f22d5f5fe1165fdb06487ed9961be753ac2f59a65acdba206571b596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d58781f22d5f5fe1165fdb06487ed9961be753ac2f59a65acdba206571b596"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a0b9634bfd7ea418cfd397afd1c75aa37eb40f01aa7da291590df58e84fd5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0580c66105548fd3a6d68ee27ae0763204834a2b50290ac17908249e078502fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d8333a51d0f3cd0c2e36ffd86722d1707902b5e1071ca1d3d84d350d207b39"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user} -X main.treeState=clean"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"svu", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/svu --version")
    system bin/"svu", "init"
    assert_match "svu configuration", (testpath/".svu.yaml").read
  end
end
