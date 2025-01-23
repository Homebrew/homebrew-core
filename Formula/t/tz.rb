class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "0672552741bd9b2e6334906c544b98fc53997e282c93265de9b332a6af7d3932"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5510e9d4d0a6cba3ed231a8036f55414352924495ec7d027dc1fcfe62004021f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5510e9d4d0a6cba3ed231a8036f55414352924495ec7d027dc1fcfe62004021f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5510e9d4d0a6cba3ed231a8036f55414352924495ec7d027dc1fcfe62004021f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecfd326efe5aaedea6afd1b998f337ab8319158da33a98828705d9592996f74"
    sha256 cellar: :any_skip_relocation, ventura:       "fecfd326efe5aaedea6afd1b998f337ab8319158da33a98828705d9592996f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1e72e63e14a004a0ab74f84f8c2076872ed232f98dc684796ad81f4a83a574"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "US/Eastern", shell_output("#{bin}/tz --list")

    assert_match version.to_s, shell_output("#{bin}/tz -v")
  end
end
