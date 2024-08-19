class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.10.tar.gz"
  sha256 "e2cd7126a10fe317c2a0be52bb3bc359ad8f2974f746b6093a86e611390907da"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9802784fe924e336b88fa8a65d27b8d2a28f23b266bb9e39851b19c57495fd7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d968ed5dea6d416129b7afc45efc788766a9989a996795cb1d18ced196b9d623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42a1ef11c5cba32a7985052154d1aaeb766783d9bc535bf84162571284afb0fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe030e530e1098a174d8d4c88d539ab42f182fd463e0362276ed4624d9c471d"
    sha256 cellar: :any_skip_relocation, ventura:        "13cdc6148006d4076b9ea36b865bdfb1a4f39166d448798942257cac317c0c25"
    sha256 cellar: :any_skip_relocation, monterey:       "580ae68908e71d55e8a00fdb4cb14f52d2fefb343ca8183ca9eb151e62002ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00144e3bf2cf39bf6c2e4bf21e07f44ca9c4c338754def840474691ca2636603"
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
