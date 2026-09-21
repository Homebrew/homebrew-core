class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "1b3e217022848b65a1b7ececa4d5e752fc044b4e8643befa1f9a8a9dc9b2bbbf"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "653687fdfe4b0ef441240ad5669997a2f000201a5b365b99d4712daa91b5120f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d48134c7f47a5de9b7a07b98be10e42780c77c852d2301b26021e288d5bb709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa382557928d53bbc02e65bebbcff20e5fe5406bfdf57a17c7cdb44ffe1b93c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "359a7fa0adc0f3c7e1b7219e06a18c7f6b3da69bce8d25c8b6236441afeb402c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52c09f3b97eef64765400e06e1d4d81adf3276867a19c1f21c39a1ba5478b73d"
    sha256 cellar: :any,                 x86_64_linux:      "286db36bd9eb9e40a00b69825f0e45ee937994ce5a275ea74b65e2c43cbdd684"
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
