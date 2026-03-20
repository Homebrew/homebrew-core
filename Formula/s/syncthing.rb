class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.15.tar.gz"
  sha256 "82ee7a343ac0b5434ef04c7dd6630dca848358039a9edf27ee9a6164e3bdd0fb"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb99b56e4d9ddd047fb4aa69422e98fa6e2274b66f057b58c9ba1913ca64c67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "282989afff2b199dad97552757635fa9faff6892eb757dedc8a15e58e3fbd5fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59377c13c07352425c159a4b4b5ecfaa4e9644f293b0a68547d1cd57f1a82d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "40af7562cac991b285833343541a84da07d6726695f7a56443abd00391753f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e6fa3b6a53351bfdb886aaa81fb51066b74149240e42d43dbef0378e7fd1d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4461c4e8895cf94d94798fb3039b8bde2f83efe183f433fe167567fe2625de08"
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
