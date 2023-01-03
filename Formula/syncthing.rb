class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.0.tar.gz"
  sha256 "3ac5002419d261b7d9352a621dbe20fada165372444824213b9d46910df7502e"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a8f1ca8d9e447af9bfcc4b7bcf486dc2d83212b9804304aeb1fa742c4aa603a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fcb00ae31912f483bde87e8ac1e9292378b3797b5320380d8c7ad8fc8f7ad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86df0cdc64f8df37927479b09aeca2b59a4f3e924735c1a89fabb12c637c85a7"
    sha256 cellar: :any_skip_relocation, ventura:        "fe45d1fbb451097bf2b7ed8bb8fbda0b5154fe00a1d3c4d70e0b775c60da3b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "974cce77ae1f672395ded04197d619976555aabf5bcf640f4fd3d8ba292becdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bc10a72ce08a8edd0d598b0f521b2c43f0efd4153e22ebec22fdb642f14d440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfa0eacaa6649c62d9534ffeff07aa4f6a60a4fe2f73d94c42d2090c727bab0"
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
