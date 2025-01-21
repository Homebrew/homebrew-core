class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "272330eb814dc79d367b18c9aa5033a507f9214616d97ac4c1b2f75054767504"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b40e84e207184b3d5ba8df0cfc15b9b0e38ac219131b10d32d59fb4231f710c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91424e94b9e80bcb352c39f8f45b9a9290fc97afc58c0bafa435ccee44ce9e8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f023f11876cb65f7558142fd39c85c8309f43eed1eb00fddd4b1bf8cbc24a3c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d308e255ba04418d6580cde651e766a55f4d75bf74af4bc25f9def4ded7e1a5"
    sha256 cellar: :any_skip_relocation, ventura:       "5f71f4320d10ebfd2f0ff012ff35050cc9015dd4252498cfd412ac2d6d85d169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731a43d294f9ca51520d2e54991972bb3e2034bf6b28fccd90e4357d65341d67"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tlsx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlsx -version 2>&1")
    system bin/"tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
