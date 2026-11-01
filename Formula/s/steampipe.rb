class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "890d0bed4fd7df7ff11c632f9eb1744f8abe2fa202302c8942b76b89b27579c9"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "402cbc61dc88d0451dc3434148504ddd982ca879fd2d4ac12e6f03a9788fa97d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c827bcbcdf5afc216e131426458ec67ae683f7125856c7fff0b8d66561cbd0c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38d0a5eff0a88bb61117972a5ead4a508f204e29cbcc0097cfc51cb0a5e6ed9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6480faf500dcd3ad6207e7581500f8f986ebdb15f124bb810ad251ed4f83c86"
    sha256 cellar: :any,                 x86_64_linux:      "14313fc5fab640f8eb212d4996a228b3f5bf5d74b9c15662e62cc368a3c537ca"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match version.to_s, shell_output("#{bin}/steampipe --version")
  end
end
