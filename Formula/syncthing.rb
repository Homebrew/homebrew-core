class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.4.tar.gz"
  sha256 "4b68cee85b63fbb197a4e5401b3983a2a2358e1098ff91755f47925a1ee17f58"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "768c78a333c8a6d5d4dcd33b26021e1464122b4161461561725369ab6775f440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba8633845f599fd80d8598c402649a50eed0a46dff689e8197b6a936b64fc30d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f5099660c2fef59eb73f68483ec5febd544640d811c94acf287a30de8226532"
    sha256 cellar: :any_skip_relocation, ventura:        "5589f275bdbbe7c328aad865b7b00bdff131c9301997c2995fc141ea8285b004"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d6d97735a0d191e82d3417d2826eeafcfb86ffd80fe9c3294aab467a2be22f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3956a43ca5da1f834e2a14b9921f5b35ff5253e37c09bc2943e12d3535d33846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799f822d2287e6b33aefd054cfa7915d66bcbb39c4e7c6463a9ab708bb9c412b"
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
