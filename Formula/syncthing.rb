class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.1.tar.gz"
  sha256 "4b355eda64b9f52d53b34ab99a1ff73dc3d5ad5e43086223e7fc7f4d05a58a05"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c197f314e4bf07afbc736f2ff7e1dd5d4d9ac99454a731e4fe3e3d27f76e987f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "152b621ee168099a4ae008c8d1c7bd1b1606b1b160b225f1d7a6a6524470b079"
    sha256 cellar: :any_skip_relocation, monterey:       "1f8b969d4d08bce4409128534fefe51caef10058389c29e21ebcb25df77063c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3ba1b7f2beedb323e2cbba26908d6e3c313ef6cd427fe3dffc92f133f61b26d"
    sha256 cellar: :any_skip_relocation, catalina:       "d6a873af84cacef36d7a7199b838094155534f849dbd5b8021e648b7e7c076b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1c53458c191f046b9bb6bde6c5cf4efd86c7375c6734f043533bd976d910eb"
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
