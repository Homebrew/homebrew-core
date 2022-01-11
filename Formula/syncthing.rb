class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.6.tar.gz"
  sha256 "b27911d4c804063b13e9474848953c2c6709218603739b5f09a7f88a69eca88f"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2716b529c9ba864dad68903832b81bd73154f0af8995a75cd0dc8ace706c50db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392dce7ba7760ee6911e28c63bee32d6f1654bca29ad622764481cfe5ea50b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "0549260b88f0590f1f8a1e8687fd20997a1dec58de66c43c44f890b7442b67a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d45568f42ca6c5ca3f97003959a25c5b2be18e970c871f55e19df1b2c06d8dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "780b76573ec224359ce3dabdf4c4caebc2e16f392baeecce72174f4acc85a645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b126544fc1bb916cbccaa05910813c867b9d22b1f1fb848c022824b5234a2f4"
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
