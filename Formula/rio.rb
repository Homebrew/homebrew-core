class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "5a3fcdc6bbad3274286bc41c5225c9ae576ffcd13b80649247656c0f41422de9"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "138a9ad75e72b321e6bd12d512c6c688c2d442df13154989c14a6f6e0f953798"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af0bcfe2e619570058eb126469934beed6aef63388387b982a6ddeaed92c1090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "286b17b798ff69b5a568b7425b19f2e9977adad95961a179a540022cadb4788b"
    sha256 cellar: :any_skip_relocation, ventura:        "641dcc654fd316cb01abbb271a5b3b165e25f8112b034cfabb617d8fb03f26ee"
    sha256 cellar: :any_skip_relocation, monterey:       "2e6ebefc0854bf62ce01e91bc4ca629794d524e50c249760c1295df5fe71cb1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ab576b9e16245be62f179f6dbc4382c00e598792c1b4bc8d45a5890f432df94"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI
    system bin/"rio", "-e", "echo 1; exit"
  end
end
