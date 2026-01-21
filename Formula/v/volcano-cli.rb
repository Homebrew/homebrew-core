class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "b0067999a4701878448fc7adba72b37b5888c8cfceaf1ceaa49a78ac579984b1"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b89776e79f0dd94c0ae7e25dadce2bd026be5ef3ad243fa2b562376ddd6ecb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e2ae02958c2542b8f8093baf48000ed95bf0a3de03fbd1404362128e09e5d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c999bc3c32df37a0b3435d58a897de2db4ba6739b6a08cc24740f338014c9711"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3fbf236eea1672adb700fddda21963242d55f0b6da02b76d8b8bf1886dcaa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d0aaf20c64c50158e40fc55ae6108f278b5a94318262bcdd4f050d41a01e4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9122d0f3ec92471b1f4dad8b68520e014c8b2cec1a83fe285026f96343325c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end
