class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.1.tar.gz"
  sha256 "2e1f1b146f18630a3dfa1480a333f39366d855dc6749fe23dc029a61f5fe4cd1"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf4b8caeaaa6f6bdd49407eaec17becac3f89b064d34d32d904ca2c97c018a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c3433dddc52c77bc99fe8007e8e0bfb2102615b45143d4a21eb534973e31d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a071039390dd9aaa0d0631b487fa6c586862f370bd2ffad49615e4db8f81227c"
    sha256 cellar: :any_skip_relocation, ventura:        "74f5e4406505f8c4cd4abf4dc08d5b8919b89da7256a84302b353bc358687c89"
    sha256 cellar: :any_skip_relocation, monterey:       "84a90e737f17d273a8c31fe7cb8a3d85987fab8cab99e3734db33e266724c3c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "892caf4a4879181916efb60d5a37d6dc8060896911a9fd8b8c422e1afc6dea12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aff2937905c367c3f0c94f76181a5666f6e079310dc956e42d0bb874c9e30a6"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/syncthing/syncthing/pull/8769
  # Remove on next release.
  depends_on "go@1.19" => :build

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
