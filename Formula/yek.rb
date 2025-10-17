class Yek < Formula
  desc "Serializes text files for LLM consumption using gitignore and Git history"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "9e8dc80daafcadff586cff6d1e3f586e25cd43cd60bc7bbec1ac8b1a96a359da"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"yek", "--version"
  end
end
