class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3996d76c982651afd483b74e440353c5a7f37a2e6080376b3a02c8380606a05e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7935a5ee2cab304667cb6f33547ceca1b83c10a55567233efbc1b56ecb7c6101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7935a5ee2cab304667cb6f33547ceca1b83c10a55567233efbc1b56ecb7c6101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7935a5ee2cab304667cb6f33547ceca1b83c10a55567233efbc1b56ecb7c6101"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a327801a74d0ef990514d0bb013e96e828b7877b78088f624d233831d101a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd8f17e0e4b1c0d1abc464d863f0b9b100639a71e47291d88ff0ed64c6f5be47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee404b652a46ffefb06101a3eaab74b023f100d7ac62b1235cbc415d8bab52e2"
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
