class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.16.tar.gz"
  sha256 "30ab1917025de0d057ae53b3568e721bbea652b4b3d7bd96b04a6ef9bfb28bab"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b52af39435da2baef7f808e8c912e43aeeb8dfa01a696a5cb994ff88fb942d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e8125d2f023afceaad2fbae1fcfa93ebae017eafffa0ebae1d3759e0a42acd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0242ae25d363575dec0ed4a56ab10e3f26430b0e01b8fc47c735988c60b6de5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "295c0f4daf9df32ff46e546a02ea57a4204aee1d94f0a94a78f85acca7f8ebc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9198d728d2af54ce6f3f81a962fe1a5d071cf8441484a3d80a658f4cd02c9677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d279a75844682df1a376f5669679fc1544b96ed35d8b189a88b223b53a805d20"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end
