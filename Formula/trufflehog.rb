class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.42.0.tar.gz"
  sha256 "d8a309d2f8618ca8bc8ee1647dfb76ea3356bb770e57440d6929f77deb63ff63"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fbda97420fa5c000dafbf47e3b20934cf0220954b40df542e8f4c84eeadc04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f34a1f45fcf371999e308da568fadbe53d3001fe6a89b6ef7453de6fefa359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcfd2a973b43b2538c12cb8f888b55472c26269dd8bcc4ac5a191f05380f21ea"
    sha256 cellar: :any_skip_relocation, ventura:        "5a5b44c678656288b3ac39014f0b3c05fe12dd829fa0a191d2a58546daded385"
    sha256 cellar: :any_skip_relocation, monterey:       "0a895f6dcef329446f99594afeef13cb247a8c121800a2194bf75b0926c1894a"
    sha256 cellar: :any_skip_relocation, big_sur:        "47ee6e1dc2e99159511907001103b987566cae676c775e40e7fb8135ba9e43c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14645a34e565d829ff3222f5ce5da2bb0dac4c63a9065a53c14102de7609517c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    assert_match "loaded decoders	{\"count\": 3}", output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
