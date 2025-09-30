class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "dfb6829483e7455e6d2038e946243022db15ea5475c096ad18f091eb9f6eb5ad"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042c065ef5a5f56fcbaeb67c1d462246a04fec0bf796788c8247478191b6d78e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d201f92d60530fcf9037fd2064ab8cc4843fcbc1d5c65a881d12874de7696d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d201f92d60530fcf9037fd2064ab8cc4843fcbc1d5c65a881d12874de7696d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d201f92d60530fcf9037fd2064ab8cc4843fcbc1d5c65a881d12874de7696d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab630a5fcbb3eb9f3809a33defe7c6aae3af94c7f70474463bee74f0c8e7ec59"
    sha256 cellar: :any_skip_relocation, ventura:       "ab630a5fcbb3eb9f3809a33defe7c6aae3af94c7f70474463bee74f0c8e7ec59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ff7bdbf48bab0cb4185f04d003b962dba23472f7669f97e2e02ba48515ca8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e1921d53e895df6d45df6aad030ea2300f072117d5bffa8c31ae3de1807b20e"
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
