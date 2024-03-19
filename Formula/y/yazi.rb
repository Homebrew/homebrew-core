class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async I/O"
  homepage "https://github.com/sxyazi/yazi"
  url "https://github.com/sxyazi/yazi/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "61b6b0372360bbe2b720a75127bef9325b7d507d544235d6a548db01424553e9"
  license "MIT"
  head "https://github.com/sxyazi/yazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7dad14105aa4656295470fbc5ccd04dbbfcd9526ed2f4841aba7284ce4252bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6273b2f7fee23884167a80c0c67dd18eb1e589aceb2f8476e1420ddc36bca95b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fefe45bc8abf233aba30aacf34196b496881b8e4ed974c46cdb529fa9aff202f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4e40eed941ea545ee9bf04043ca036ec4ae9ac5bef651fc81db97cccb05fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "8bdfb9d318dc36c1f55097e82a345f151329d33b492db53343812f0f8a4e94a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e64c957f1e41a08c8ebe495f800a74ad94da96fae20f3401825201f09cac8dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1090777f639528ca1db841e46de98b39c5542f2648caeef4a7beff2965c99b14"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
  end

  test do
    # yazi is a GUI application
    assert_match "yazi #{version}", shell_output("#{bin}/yazi --version").strip
  end
end
