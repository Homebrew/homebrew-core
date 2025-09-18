class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "85e3344a5613b7218e1e8e31e2a24791524f22f1bd2abe4a9b4479355ccf9915"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a89854ceab778ca85612cacb1de2d17d4a46b1aaebc09e1b067eb237fc83434b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e18d56d4dc7629f877bea41f9838929aa6c9adca941b4028de8647cec60cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9fbe47aa6c76973eec5ce1121fa1808fb8b2eed0f53950e09b1b05ba9cc6461"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3937fd22d42468f2058edbbb8484d63e3a149ea0cbeb7bdeb4970806e0203d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d2384bfb2dc8f5351c60994247f93f8f73807ec71fa304dc2b1008d6a4fd4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a622e7a99a6e35f813c6d9ca58df0859b112a23306b427e471d969bc0c3619a3"
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
