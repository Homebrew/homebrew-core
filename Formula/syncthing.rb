class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.4.tar.gz"
  sha256 "0a2a26188d30bcb92a14c7f795790df9f44157118248dc4c9faca42967ce7ce7"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47c3aaa21ea3540e3331236a8db77bd1c0daa58c2417f3c9e8a909ab849a882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88cd2be88d088b71437fae58890811088782c3b07d532a2c6e8abd31f3f2e210"
    sha256 cellar: :any_skip_relocation, monterey:       "ea0877b124af74c3cf9421e50401d6382e7f565030d1937dc39e47ad9402ae12"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2857f32937ce82347445891d0db10dec46d8e63266d70cc3e9dce127ce3f96"
    sha256 cellar: :any_skip_relocation, catalina:       "66c6499c1e0d80f8cc22f6585cf22b8c434fff14378579afb2c42034b1c2eda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780e5c011ef810cd16456bacf56b8826c345416a9e0524709027cfdbf37bbbbb"
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
