class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "07f89c901336bf9a85c0984c255d4600852f7465de4878bb0d530543bb7dfe97"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c53f37770607b291e27208ac6f198b2dae8992844f0cb6600536433ca14c0b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53f37770607b291e27208ac6f198b2dae8992844f0cb6600536433ca14c0b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53f37770607b291e27208ac6f198b2dae8992844f0cb6600536433ca14c0b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebc76d8f9950fb6a058938a16ba38933a68128e5876fb3c02b75da4a9c92271b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b731773aae2fbeb438e46c8389c5c3c4ea7de29eccb50dac7d569bb6075405e"
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
