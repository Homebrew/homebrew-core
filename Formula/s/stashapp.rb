class Stashapp < Formula
  desc "Organizer for your explicit images"
  homepage "https://stashapp.cc"
  url "https://github.com/stashapp/stash/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "23402a61329d3c57f0d161e469b07a14a7672f799ff9d97bf082c1b67ace2dea"
  license "AGPL-3.0-only"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "ffmpeg"

  def install
    ENV.deparallelize
    system "make", "release"
    bin.install "stash"
    bin.install "phasher"
  end

  service do
    run [opt_bin/"stash", "--nobrowser"]
    keep_alive true
  end

  test do
    system "#{bin}/stash", "-v"
  end
end
