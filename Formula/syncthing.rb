class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.4.tar.gz"
  sha256 "0a2a26188d30bcb92a14c7f795790df9f44157118248dc4c9faca42967ce7ce7"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512527c4eb635452e44a85cbafa093cc5c3cb8deae606bbadbd13fc397150630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1062ee9674092d10855e2a03adf652b7aae8faf6760eaf9fe9afc5c68dff4d91"
    sha256 cellar: :any_skip_relocation, monterey:       "6db73b805403841df911d4dce174dac918317cd2b3587f5a2ca258c55a201a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "404ae295a0062ab7bcf4bca131fc75b3a4bd489956f57c4bb168cbd1663bafff"
    sha256 cellar: :any_skip_relocation, catalina:       "5e254b3d32fb04be512ae031e398ba899cb23ece7c4b524ba19fcb834c9fe55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d8b93233ba1ed97f2c5e0c66d3915ff3c736573c2a9fc80db81a40fe1d427e"
  end

  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
