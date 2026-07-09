class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "cddcd03945de492f5c995f6fcda910fc49c1174a74899a26704aae63aa558c4a"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba72d014894bb1f84d7421bd2cdac0c23289057f54edb7e566b64e8b9bea7f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce156877e028090ae071ede8652272f819b0b040ee777c5eb7725c443e6d0e14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fa90e8e6b2216996d3a7af7c377f17533813ef0618ed2cd2519d048ae406d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbe441c2ae7be1ced1a1aa5b0865ae179bdd83cd95cefded10bb439591efc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c492ccead3dc28fc850e81864a2b4183786515412956a8539e63e24496edd7b"
    sha256 cellar: :any,                 x86_64_linux:  "169f5ca29b2753e950530ed68f78647be0271ec3d36672a922e24f0185ac3a1b"
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
