class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "c68a2b94d22c49238cbd91151e4781b9846192f2cf0790e2d8d1a4caee9409ef"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d90952e9f200dcd7c31a76956cdbf3b7403047b68574d39c5d943d56e8016287"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91e3331d3419f2bc23f242699eb9436ce7ac379d68e115ce7db4bcb25720ccb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c338abba437bfb7eadb39377936cefcdf58a0626ee7103f35a0684e1ad06b1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78b0bd2b8eed3f27ceba371c8a9437851d798038758cd309a306de9591012276"
    sha256 cellar: :any,                 x86_64_linux:      "efabbd52cbc58ed20bfd23c354ac20f78cb65c531831202fc97bc20107c78cec"
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
