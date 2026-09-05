class Rdap < Formula
  desc "Command-line client for the Registration Data Access Protocol"
  homepage "https://www.openrdap.org"
  url "https://github.com/openrdap/rdap/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "90c8ad29468cfb774c166a371b164c1e2a37de088e52328f4b9d5c80c0e23d98"
  license "MIT"
  head "https://github.com/openrdap/rdap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b05cd27d41d07fad35309ea77f9968beff9872ab9e9ce51b062576a86b6dbef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b05cd27d41d07fad35309ea77f9968beff9872ab9e9ce51b062576a86b6dbef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b05cd27d41d07fad35309ea77f9968beff9872ab9e9ce51b062576a86b6dbef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7976c13f79ddec0bca17b6ebb9e9d81cb6fb97f56c34df8b46856cb78a4131a"
    sha256 cellar: :any,                 x86_64_linux:  "1bb9c61f13ddc3b56a677241c7307edc3b1aa317f6f8e74a9d6e58afd21f5dcf"
  end

  depends_on "go" => :build

  conflicts_with "icann-rdap", because: "icann-rdap also ships a rdap binary"

  def install
    ldflags = %W[-X github.com/openrdap/rdap.releaseVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rdap"
  end

  test do
    # check version
    assert_match version.to_s, shell_output("#{bin}/rdap --help 2>&1", 1)

    # no localhost rdap server
    assert_match "No RDAP servers found for", shell_output("#{bin}/rdap -t ip 127.0.0.1 2>&1", 1)

    # check github.com domain on rdap
    output = shell_output("#{bin}/rdap github.com")
    assert_match "Domain Name: GITHUB.COM", output
    assert_match "Nameserver:", output
  end
end
