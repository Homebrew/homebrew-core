class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "a3860d01f04dd6aa9f3a1d38ec9ba5dc7819cbf126660c8721bec5e6ee2baf77"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "30e3f794855080383ee0668e4ca3047dba5b71819cf95f04e225c49966d3b36a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3b4f77e4fa2fb0f9476a3aa80e397e806e7a58b9ce8cae1563ef5d82fc1e2f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "203291dec96c2fa857b95abde74d84e841bc5729fed5aac28968de99b2ef536a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d1d849441fb844355e469ea2d93dfbbf7cf214d2e87d4b25bcbbfaf7879cf00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c05a9ee95d38fe7449c47c3c88cdb01faaae7abf70aa1e46185d7096737ce84"
    sha256 cellar: :any,                 x86_64_linux:      "55784db496ed48d13c09990b6185e7d45b451c14688faae5716384f08b0b356d"
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
