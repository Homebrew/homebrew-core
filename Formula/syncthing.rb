class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.2.tar.gz"
  sha256 "6733ae6947497ace959c56f7c491b785ec058c8592cfd9824bc37125d1f342d9"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "357605f0736fb1d553e420966d4e8df409d5a8291f2e176986588d2279004ad6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e757e8289e62b29fa9ed11d015b9cbd3b663ea502dfca9fce2194bd194233687"
    sha256 cellar: :any_skip_relocation, monterey:       "20e6eca68be27ceabe2eb4538c310c21b4234d27007e4f3cad9bc54555991a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "af82eed369f22b4b6809c9ea5ef8852aae72aac9ff5e536231dd1f12c077d46d"
    sha256 cellar: :any_skip_relocation, catalina:       "bc5d7f82ce2cc5e55c921f0108cb1111a7042f0a6c6d060146b763e91dfdb95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5e32ba3811fc59ec547d151fd3a113f879e55e49e24bc4f5ffce9a3b1f4c61e"
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
