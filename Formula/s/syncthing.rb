class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "912cf0cf214a3cb68dedf88fbafc78bb842bfcdc857f5e26c4d3a6971f1a5c8e"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eedc43241cd948b16ff7aebade999fec21dec606d8d56ea083d21971bdbea7ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9da1b5e7fcc61dac506a8fe5b05a5c991aed7428defd341af27262b867ff9909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "577dd9302d564b2a751e182604c34e68cda1025519847c2c727b0567f8adb303"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c2e4357e2764fd7200353602ef770f2104901aee1407e8702c6359715fca14a"
    sha256 cellar: :any,                 x86_64_linux:      "57c131c16250cde6ad0ebddea94296a7b53f176591406d40a59d283215ad469d"
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
