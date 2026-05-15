class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "fd8026343ef90730eac019ba5c29702750312d1dee7f2c078f946fcd09e98d65"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8a900f5c4b63cce369f4dc51fe56a359e32318e8dca54002171019b27ad6981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c5dc3e120ef08f41c9c5a5a0c77cf36a6227d706d53a40653ab117ad41debd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0147ad4ab408d7db70758efe67cae909927ad1eb2264d720ac30dd74c6ecff36"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbca8968eae503bb25c539ae0e2fde49f2f4643140a06175c46a74bc64168b26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e483def8d7a92f099b7652c98e40d0e6daa3d3d6e5212b9e1494423fe6c45b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0aaa8a0787790154a6a521b4c8d1568bf86a1b5472c86f329ca2a0c34053786"
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
