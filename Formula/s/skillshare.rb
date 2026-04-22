class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "64075b5cd4c8eccd4be39c1b792e5cd31c0d04f8ecd1cbe1ef21bcf7e12731d2"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c48409cc7e40cb8e5d36e5787f2311cd3504ed49af26d9e0f988f2f7b78bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41c48409cc7e40cb8e5d36e5787f2311cd3504ed49af26d9e0f988f2f7b78bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c48409cc7e40cb8e5d36e5787f2311cd3504ed49af26d9e0f988f2f7b78bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f414d5fb4ea0042ed4b82fc4949f2c5b351ef7309e8f70b8f1b823743877ea72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dcfe225c079babfdac090c6cc9ec26094bf935e98e321b76f46d40b0c4603c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61efbece86a7dc2463a38ff8f99b80de1d0b12598f818cdb12aabe98f509f2f0"
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
