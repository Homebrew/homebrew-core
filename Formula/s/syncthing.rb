class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.29.6.tar.gz"
  sha256 "9731b302f3abcf08a29b0f404a46b26d1f3b89bec0e2bc40313471173da8358d"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ebeebb7a79c75bab5773c8bd59f07e2907d0f8a8748d86dfb72e68aae7cf95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40d533e9300eff8b4d72598eb4a3f716754f1bca314443e3b4787b9eba6d08f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9c30a65769c2e1d29690bb3ba0b5563e5dabb0f70cf905f35894d5af60d6c31"
    sha256 cellar: :any_skip_relocation, sonoma:        "462b004baeb5698e3fe28e279e51e1191f86144ffe7a3a7ceac190b673c48c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "54d0eec94de14bb75213985ce2de98d9e5f002e39a25320294310e7e2e17e064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b04b48f1b0f190cba1dbfc37bf415c426213024481748851381f9378cd7af54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb8aff18045b523bb414b22066e4dd187a3e4d4b096037bd36ef9bb3faa7ebc"
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
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
