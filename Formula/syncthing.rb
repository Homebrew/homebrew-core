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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "315f4da7a25d71c88cdd0ccb0753badaab6eed131dba1a74ab313966648e164b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5042c202560a3a547d97f15ba0313e1fc91c5a18de30425f5b5d44fedd76942e"
    sha256 cellar: :any_skip_relocation, monterey:       "18d9cb9298d8f32ed8d62dbba157256fe8819dbcc50804b8821eeb0417d3898d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7180b61ffba7f52e59ad548a8f938c26052e7583a00071c8b0c08ded26f1d400"
    sha256 cellar: :any_skip_relocation, catalina:       "86cfbcae5c7d393dff4521760941a9ae2969d22d9fc880c2e42c420e2ca2844b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65efefc6c47d11ac6d8cff91a963cad1ce3d5d6e15fc37bbf5ca02b69cc26860"
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
