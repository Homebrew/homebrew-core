class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "a90039d703688dae876fa3851274a5893333986e609a04b2129ed32704039a91"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6b82ad701a35acf7fa4744722e9e3c1dd4d07d1105baca477cd39fc26c56b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ecc54fe96ce5a63ae65669cf81b8725a6b1cfd017a44e4021c0202ef95466f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ecc54fe96ce5a63ae65669cf81b8725a6b1cfd017a44e4021c0202ef95466f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97ecc54fe96ce5a63ae65669cf81b8725a6b1cfd017a44e4021c0202ef95466f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ecc7ef92ad0a839ffbfca09dd3eb8f0aeaad36f901a141f477896dda5c0a88"
    sha256 cellar: :any_skip_relocation, ventura:       "d9ecc7ef92ad0a839ffbfca09dd3eb8f0aeaad36f901a141f477896dda5c0a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf50952811efd492b4e0a326218dc85e96b03b26dc576eb136619d34311103c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
