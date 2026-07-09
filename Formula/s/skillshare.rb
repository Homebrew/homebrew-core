class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.21.tar.gz"
  sha256 "d38352821a9837dd5e7d15be7e08b9751a6fb5d66a7e5efb0d0582f7765ee9c3"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecbee36c649701379b9cd8af9517597623f2d7f2a58614819a7b67e49f070c75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecbee36c649701379b9cd8af9517597623f2d7f2a58614819a7b67e49f070c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecbee36c649701379b9cd8af9517597623f2d7f2a58614819a7b67e49f070c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0fd26b5d93a06721043570a10ffbd1d71f2751b556faedd39cec3b39671971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b73215969a0b3c0c9ded57ee901d5e3f04eb5fd3e818b554821806382548318"
    sha256 cellar: :any,                 x86_64_linux:  "275f99d5d78b10c5497da84a2820a3366c1d4893481e03e2bc69fc7664b4b5cd"
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
