class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "682940b141bef4b4c58e42eed3aa05e5586e5b179898967d49b3b12029ca9206"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9995751ae7ae7999bff65ce14685eb9030574035fdeceb3e751006e0f659db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7caa3b01f61cd992a41eadfdf8142ac8e64e7806fa99a008590392ad8b73a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ecdf221e461c57ad5c04682a1d92641b812ab39a3664ccfc08c0616cb15580e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f40dfad93e2d7069d2bc885ead7c14e10740b4ecba8637679aeac41a6f57ae1"
    sha256 cellar: :any_skip_relocation, ventura:       "86a34690a8d87ab397093ea40bd96425266a16a8be1169e476ad2230af7a957a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcb722cf447b2b713fe267c215ea35a7c8411bb0596ec861d6cb37aadfbdec51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa690fba22d66f7eabe2fdb4f23fa1a11c7e0cf8a91d95f81bdaf3929087ecd5"
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
