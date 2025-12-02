class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e20b39dff98c82a791ae9e5ac40ce78f6e25a5beac3ce7b4d53a3c0b45794f04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35a73401f7fa6b69b6af81402d8116722f47a846a8853fe87d34a5139c9f7bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35a73401f7fa6b69b6af81402d8116722f47a846a8853fe87d34a5139c9f7bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a73401f7fa6b69b6af81402d8116722f47a846a8853fe87d34a5139c9f7bc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cd5c4ecf1ff7ce9d33aa4b3f6e95c5ba82810c8c0452b28466a7007f4ab3b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c62a7a554861cad139d2b4bf8d369a7b988cdd540cff391d63bf67cbf368b7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e4b8cff66df393723fad3e63f4bc186f5ee9dde268c2f3b9d1075ada5812d2"
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

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
