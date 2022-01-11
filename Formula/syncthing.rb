class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.6.tar.gz"
  sha256 "b27911d4c804063b13e9474848953c2c6709218603739b5f09a7f88a69eca88f"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c916770e66ff9b7276f64e06cc736a03bdfa8b2d2a001847d3c9d5da3dcde3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46245d158b4f9eefe2846d56f1a8f93947a48dfeb1c71e1a9affe30be9d49cd9"
    sha256 cellar: :any_skip_relocation, monterey:       "80cbca98f3fbed4f7e1ffceaf2c1727d4ae9f75fe72530e8dcb7a011ab6aa564"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c1e871859733a15559a916e9b23ababdec814292347ad3d1ad3ec16bf26bf0"
    sha256 cellar: :any_skip_relocation, catalina:       "daa7228081c7cd2ec62e97ff74d36559d81e1ce00fa33d82151569619024e1ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f3f4769ba3eebf8e1791e1e6dd91c83a0c50cec454d0b0782f32dfa04fd007"
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
