class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.22.0.tar.gz"
  sha256 "5e68257fc0f188f978e146fc160075bcce80af54ed2202d036aa05ecc61c3e9e"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cdaa18e83930518aa835fc46930dfc15dd36d16bcf9705e4d824de325814a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfaf0ce8c196919097c14e46eaa8ccfc8231474ac3664ef01ba0591e7d07ff40"
    sha256 cellar: :any_skip_relocation, monterey:       "5b2a1304580a0f2a71127b530e96ff4475d111cc2ac5c4c35ed719580ded27c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee104aa6b80ea7005b4c21ea3451e32a875adeb875a9042d46f85af912942ec1"
    sha256 cellar: :any_skip_relocation, catalina:       "32ba70ef47fce273a4d352f525b38b051353b980674d446382df9a1a053d4655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "647950088ffab6a76392f63c35b291e2caaccf8f9cfc17859aacaf5d5912a4c1"
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
