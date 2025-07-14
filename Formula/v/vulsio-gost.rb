class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "8812f4874acb1ccb565def5732bedf6dbf43e46ed1de3324b8ecdd908d5943dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c503f4dcbf1a4aa65ca07d40d600f9bdfb1cc528f20360561cf54615be0a85dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c503f4dcbf1a4aa65ca07d40d600f9bdfb1cc528f20360561cf54615be0a85dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c503f4dcbf1a4aa65ca07d40d600f9bdfb1cc528f20360561cf54615be0a85dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa84053bee3db2caaff971039516194598656d39371a3dc312913c34aa61e40a"
    sha256 cellar: :any_skip_relocation, ventura:       "aa84053bee3db2caaff971039516194598656d39371a3dc312913c34aa61e40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d45c94dac320f5b899e6bfdff44fb024b1acc85ebead4e3cd80d5103dfc62d4"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"gost", ldflags:)

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
