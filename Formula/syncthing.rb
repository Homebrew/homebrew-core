class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.0.tar.gz"
  sha256 "27d9b52f18ebd833938731ffaaeed4f34ced534ef3d1ed2bc126a495764f753d"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e9a8b0d0a953067fd419e85da3d3a50ca413844b96317b73dbc53e3967d389f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56ddac3b0b14ad4bbea6ccc75180c06a24e07420629a37cdb52d7d9ace1fd1f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b3adf0004ba7b12b600435b9c9e8e86f18f9834fab13f7c99e618bcad49dd9d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7414e39803b47bdae5dd717e341865124bb521e25fb4d22959310adc1bd8e93b"
    sha256 cellar: :any_skip_relocation, catalina:       "69018658005706c5b3fa81b0e963451db1d22e3c0cc049621520d9380bc58285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53b44fb97aa289d016f5344fd819a82e46d7283b6dc9a49ec9174863d97534c5"
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
