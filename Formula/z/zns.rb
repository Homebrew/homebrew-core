class Zns < Formula
  desc "CLI tool for querying DNS records with readable, colored output"
  homepage "https://github.com/znscli/zns"
  url "https://github.com/znscli/zns/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5e7b4cf641429fa153df24d2088744ed5d09ec9d77151c828611262f85feaa15"
  license "MIT"
  head "https://github.com/znscli/zns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b44e23dcd5f00ee7363edded2f65a8cff2e348a89af0ed97c267278625e285d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b44e23dcd5f00ee7363edded2f65a8cff2e348a89af0ed97c267278625e285d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b44e23dcd5f00ee7363edded2f65a8cff2e348a89af0ed97c267278625e285d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbfa115c982914deef04f605327e1c320967d436718a3d2c0389156713ece26"
    sha256 cellar: :any_skip_relocation, ventura:       "9fbfa115c982914deef04f605327e1c320967d436718a3d2c0389156713ece26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f3eb0b09363071f64391d43668b0437106910ec44340a3afd00dc27116bd92"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/znscli/zns/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zns --version")
    assert_match "a.iana-servers.net.", shell_output("#{bin}/zns example.com -q NS --server 1.1.1.1")
  end
end
