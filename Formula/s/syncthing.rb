class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.29.5.tar.gz"
  sha256 "8dcef38261bc1f0388dcb85385822594573a76ff31a874703fd2d2699250040a"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81368011f956adc48ed8694da8e89000d683af323b59790b6b665bbf4c7601f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbc27240ae0b8eb6c836b433dc85069b4a47c145d481538622f38b6e2eb9c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c7e28f688f2811de76a648b603e178b3d4ccd32f589a6c7974142daaafad723"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d7468cfdace38af4d0d10f020162f9492c07a8ff5cc655f439846206f12f056"
    sha256 cellar: :any_skip_relocation, ventura:       "5ef7f1a10634695fdbab757afa8b47fbd739b3a70d35b3b99feea8303e29df98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca054b59648c652fc2bd728c13d8b1ff56b1c954271ea2470a77c42ab31bd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b5c007f8eda757d68e51673ec63ee0463d6a16ada704c07f3e3f15ec417948"
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
