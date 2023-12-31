class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "e91671a8291a6d83264f1d1ed731fb6041b25d7259400e5f71cb2d241a48e6a4"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "476ae93a4aa436e4fdf41a9ec01cf03448e9999cb087aacc429b65f0aa1606f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79afcbc2f51626be3d02e0e44a92fbc25891934e0a4ff41c5d71fc805d5b7b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf68d7b4ace1401421f477141bf609569581b72e438500a0ecd7c133e370fb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce611143acbd0ae2d79d6a202476929faad4e0a78e22e19556c133647d72b295"
    sha256 cellar: :any_skip_relocation, ventura:        "5b9ea213aa0b4774811e0f9d748c3369fc3463f51a6ca48d82a22ed64c8a8a29"
    sha256 cellar: :any_skip_relocation, monterey:       "36846d97a9927515dddad3451c708fe3e4361f347b27960f5ef0867b664ba07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8c00cc77b36c8132296d54bafc3baca8807e2906b9a5dd03c8304aef80a0c0"
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
