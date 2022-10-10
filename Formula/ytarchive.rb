class Ytarchive < Formula
  desc "Archive live and upcoming Youtube.com live streams"
  homepage "https://github.com/Kethsar/ytarchive"
  url "https://github.com/Kethsar/ytarchive/archive/refs/tags/latest.tar.gz"
  version "latest"
  sha256 "29931b22d8cb22ff6aefd2f4601816eb5c3664ec88518f9da432e3d460549923"
  license "MIT"
  head "https://github.com/Kethsar/ytarchive.git", branch: "master"

  depends_on "go" => :build
  depends_on "ffmpeg"

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"ytarchive"
  end

  test do
    system bin/"ytarchive", "--version"
  end
end
