class Sniffer < Formula
  desc "Modern alternative network traffic sniffer"
  homepage "https://github.com/chenjiandongx/sniffer"
  url "https://github.com/chenjiandongx/sniffer/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "c8eee0fb34422a014811306b9b2d2d149c469b3a0c515f79bfa516bbd2f56979"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1913f84c2049d323c1a00351af8c08f8e37583e014fbb4e83f30f95be7cdecc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02cf38bfcafd1048f1be0a5fdfa884f604985f365a520a766a59b4ce5e6ba09c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1625ba44c2921e587efb6fa71bf456f5e41c93f830c4c0a01211d43ed10ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aec4de8c491266d76a362e7f5f5851d339514b261d80cd305dda0260c8a36a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "336a7007da692ead0a69480e2086f7a16e275a1e0d2241edf9ca386d055e9e94"
    sha256 cellar: :any_skip_relocation, ventura:       "1c672efa51414608c7bb0e4e05414f826747dc0d48901e83189ca443a148112f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5165aedae90cd16a953bb9ce088139f2bf355d53db4567fe0b5b66c360754bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355872769c22b29aab4af16277847c47cb00fe4965ab90675cd523c55b504e66"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "lo", shell_output("#{bin}/sniffer -l")
  end
end
