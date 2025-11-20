class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "ed5b120ad4bcaa67ba9d236229f1bd3ebafad92fb53e7bf259d22d5a11a4a46d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb86164ea3cc6bca45467fc44c9c9f79e0ed85c8f3816f28e6c268ec7b5a0f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "778ce89ea691a9ebf10d266f73b4c90cb26fe63be2aa12b1917163db52302df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a769a5bb4972ef09e3601675d69a38103a23de1958d9255669f246155a7edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "303721d18416a380bc496e90ad8fbb810933000cd8d5cfe9f36cf8cc7e867059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bd4b409c6dd2103abe8f0b1d435584f1297e15591eb7a98948be9449b23570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a03e9315e2df7cbcdf7a8d5751504b19005111e2651027dd19e2c13e55bcc86"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
