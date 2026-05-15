class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2d3d16eea65b73f37b1ed28e2bef9b16ee5dc35b7a0cafaaedca929003f1eed0"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "874d8e5ba83d6c779294781d0b206737375b02f2cb4fabde54bf8e7846c157b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64908bac7b488755b10944b620bccc3351cec30e1212c7a1e0d354b334481afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f042622c100b9c2955d36c9af294241b538bfc60e8f204eefdb6dfc3d180806"
    sha256 cellar: :any_skip_relocation, sonoma:        "99210a70877cd490de9a89adcf3393f1d120d3898b8d73d659be12a2b03cd3b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548868f971b346de6048d33e75e5ffe4d821eb7c7f6ee7718f9378f9c44857bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626e608a788743cad9e5f68cc4e44a553a7f6b69c7d5f965c43f0cc3dc83df66"
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
