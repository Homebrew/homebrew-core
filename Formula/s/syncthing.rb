class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "d873960f3c85a9141189e76d680e02b36b6e988480aea03697bac244ec848864"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73f99357feaec15c751a6eb497354e6970b2a5ffb83cc954864fbab60c2727d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21b3d61f3a339d61f125c3067882106f2b469fd880014403369de588dd8bb290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa2ee95fbeec32096915e3cf3d6325d1aac6de4c6004bb91f9b50e93f2ae103"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a554a5ec3ae39a901a6a9499af39e7d3ce8c351be076b43d7670a3def4d4ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac466e58f9e4ea26cfcdada1685f4d52d268833843215b8c2e947dc26e92852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0e9971880c13f0d7fd932bfbc732dce4e58ef90a32785f92729dc7653e5a09"
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
