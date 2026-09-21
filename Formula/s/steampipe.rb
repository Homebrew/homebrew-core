class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.7.tar.gz"
  sha256 "1c0bf12ef7435a39a74414a23fac1fb155febf7b234a4aa0a01fa60be04c7f41"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c1c41741eb236a229bf996294880a8fa46e0657c2a1b7786f6c110fd7486834"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8064ad311733047aa6cb97d873a0d88932b1f6bed1b197f328f0da92c32b0c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74b3864367fb78412e2ee3e1bf67a3aab49a5280209df86128224ece57a80241"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd9f3abdde35e5df8e46d81b3cec8255949b6af6b2a813feebe36862ef5c2468"
    sha256 cellar: :any,                 x86_64_linux:      "9c30375abc5dc463016dd8fb3ac6ae04346067a25b9b5b5562ce0d19715de1ad"
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
