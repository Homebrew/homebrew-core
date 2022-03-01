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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9798917daa4addc5b588ce6d51f28d4896832caaf22ac85da4ba3deee41c5b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba2b86053b00962097aedbef31d0afc44a49830e66c9ebed385df12fdc28451f"
    sha256 cellar: :any_skip_relocation, monterey:       "7c4c5e3f2527edc89660d83b53f819c1349a8f5b98b7aa0a7324d6a5750f39ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1c6c317189f5fae6889ca8ed69d68ef9309a05e23bbf13be172e36f93dc6ba2"
    sha256 cellar: :any_skip_relocation, catalina:       "ec5d028bc1f42672308c02e9e42948a8765196c82ae7b9e49a6bcd3d5a6d6c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e796b9db732d93ed0e50702d564926805e6400a2439c96a459e1ac304f2826b5"
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
