class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.2.tar.gz"
  sha256 "6767e808eca8e942a408518b0d6312cc4271e22c35f7e22c097c90f30bf854a8"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95818c51bf69eab308d3be647a28914d429fa488bc33ebf29b25d55e3737630e"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b04909a54196383a1bc58e7b6a2aca93ce52b45aa6021c283f6eef17ce86318"
    sha256 cellar: :any_skip_relocation, catalina:      "3f8c0f6c14c697bf2f209bc8c3a79809d7ca92dc6e9869e9f84d221167557b21"
    sha256 cellar: :any_skip_relocation, mojave:        "3663bc888dddde7764073352de729bd8b89c9389bc133cc0702df1e5fca60775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1458439f2e6909a7f70dededb7b56899a3990daf8bb873d7b4a5bafabe00aa"
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
