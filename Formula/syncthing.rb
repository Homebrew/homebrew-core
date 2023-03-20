class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.2.tar.gz"
  sha256 "036bff4610791aa278a40cdda530e412bf44958c7951b720160c31c87b03d61c"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f38202452e04d2792a13ae4163c803fb36e5d32c3c346881fa1a5e4896df725"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255051209c261de1f9097e32cc78cc20b579e4592fd1af18ae7369979d3b3615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "415492dc76a5afc6fd87bde5240c9a86cd467ebde04353b1077708e7e8c6d5b7"
    sha256 cellar: :any_skip_relocation, ventura:        "f0531afb1c4ec4c56426d195fb34a6e23e213c8f132cdeca1e7f79189d212470"
    sha256 cellar: :any_skip_relocation, monterey:       "0981cc59d6dbd520b7b504a3d8227d4984bb91131a19dda874791ddd28e56266"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3b69e6daa66860c143bb88699c3e79fda2c514c478ade316154eb188208cd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49079dd6ac980eade7774193fb0b4b9c956c1b8712abfaffc3416f6667d50e62"
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
