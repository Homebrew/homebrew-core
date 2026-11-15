class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "e9794cab0adf5b0a59d9b631e994dce055c57cb805228555bdfa68118be4bd0a"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62ff123f2be7ddec236279324354bfea2412641ee45a5c1f3daf2254a4c836c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0c1b0fa89bf007e4170322d0070555c89b72be06f56d2001378c534f01c807f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9090a496ae06cd4c0f6f55d0b695b7d784c132269257c426c72daabfc43dc3ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f756645bb12c7ce359aa7ae5706fecc69c2ed1a09bbee4d46e98bcd71454c39f"
    sha256 cellar: :any,                 x86_64_linux:      "2691a3754f48cf1b9c06c19ffe6a0498035399bcb269dc3ec9ea70c0cddc7e10"
  end

  depends_on "go" => :build

  # `test do` block binds local ports for config generation
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
