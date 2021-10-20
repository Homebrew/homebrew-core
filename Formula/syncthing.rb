class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.3.tar.gz"
  sha256 "b985779be61582c70e86d5e439d7a4a93eeeeed8bbc65de28d1e3d97aeb00e01"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b240136fa4c0ac5360d2c9517287c62f1c6cce1e69acc67f3d61359caacc091c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d9480593d9c9defadc23f88c7ddac53ed99bdbb7fd19e753ecdf5a14c73f84e"
    sha256 cellar: :any_skip_relocation, catalina:      "c336b71bffaa59327cec7990ab76c7bb4d3bfc2e2df758b238adff379b7273ca"
    sha256 cellar: :any_skip_relocation, mojave:        "1a66e3d133bd82eb098bc0c60c1d38201ef45ee05b3f72d8be96448901aefa98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615b17a55c4c0f564a8c79c23891ce8b982ef5b3d5aa47069c1f36a37fc2032f"
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
