class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.19.1.tar.gz"
  sha256 "46319031c0805374baa382ee2b21290fb9dc595b70e905b97eb9a5643a78edc4"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0cf1bc731b11e13c4480755037bba50d0290998c9b0c524bedf1a7e5dd501b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c3a0ba72591863c247b1cd38d12c48e8d7a54ad1414cf4a6c3e9936d5ce7a2"
    sha256 cellar: :any_skip_relocation, monterey:       "36b01bfdb55a4caf5c37c6b113f1c75f5ce8c780c70a559bca174f26cb5a85df"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbc302269a69ff7671f1186dbbf4260fa093ac7cc50ef542b63cc002be0413dc"
    sha256 cellar: :any_skip_relocation, catalina:       "e311ea63b2d6a744d0baca4cf1d536d1ed271c103cfa9e9341a9adbed0be4fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53ac2f79c207098b93a474e2f36e7a8b5112912cdd5e1e8b2dac2b4f3bfec74c"
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
