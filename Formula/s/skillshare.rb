class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "c6824dace024a2b9f38f4e509ec0b4de3912e4dd2d7852591ac4caecb7e6c996"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42e17cbd8ce94ef833ee56b11646b89be79ee311160c46cbf6636dc505f68488"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e17cbd8ce94ef833ee56b11646b89be79ee311160c46cbf6636dc505f68488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42e17cbd8ce94ef833ee56b11646b89be79ee311160c46cbf6636dc505f68488"
    sha256 cellar: :any_skip_relocation, sonoma:        "d956d43d5cb43d29c5d0b699ee3692dd8425ac926fb335da9b6cca80db7ae205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44a9064fa2bf60f9fa787a4397ce23885e13f345bdfc9e8a422978b273e6740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dea4624b54fdf48339892c29be0e4928b00a5fd6b8038ccec410e6d6b16e7bb"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
