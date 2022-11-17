class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.22.1.tar.gz"
  sha256 "f4695feb47c0c59e00a7e1ca458b52b2c07512ab4f404aee170b2d5ea57e0fec"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba274ccebc3f0181b489559b42e81858a6a7f3a545a9ded7eebad9be9d9f06cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40cd757b98a29fcd395c4a21288c1247c5b1e4365aa8d38d65b50d0069d5e80f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd1fa0f1e17fe712ea570448ed155bd0f80a2a9cd4777c04bb16158c58b3b6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a62fe4eb60893159d673e779f20ea4e1168860bf1fdd97886ad26c3b681b95a"
    sha256 cellar: :any_skip_relocation, monterey:       "a981bdb5da7abbeb088fd6180e8726f105a92b8d0515cf29e1f5c5134423e5ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "261cd18b3f79b23842b7600b5d711ceaaeec5827c9f05a1670ffe00c4e6d94fe"
    sha256 cellar: :any_skip_relocation, catalina:       "d2b6568f4ca47d02ea6c7a15eb50d304d6dec9ceb97de03a93b3caa42c4839c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f839d5ec85255d56666f5d5e64806b8c1edf52e90f6d131c97d56eb185258e"
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
