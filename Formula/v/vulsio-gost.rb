class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "00f1da4210b20c4225b78408e1bc519f38340039c4a82b6c14b115b5c805bf6a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df9c6ac1df41a22b28b0c1dc0b737be77dc7e4d30966150643a5736eb5379ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df9c6ac1df41a22b28b0c1dc0b737be77dc7e4d30966150643a5736eb5379ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df9c6ac1df41a22b28b0c1dc0b737be77dc7e4d30966150643a5736eb5379ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "00e44cc7abccb140fcc53068a8aeb8f78ba283c46592cea7613d946fdd7384ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a21670c2f8559076801cdd67fefebde38508d34a9cabc2de730f8b5e5fb40bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4190e90c79d58465830bf6d5ab383dbc2dbf1fdc65d860ada2ce6b6c66b9e176"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
