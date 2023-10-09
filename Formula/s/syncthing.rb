class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "25948ff788d98b74672b8fdb67a414b96d7a28cf9c48a52b32213dbc34d6bb65"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a03e460a79aa72c696507baac91d137dc4a1013af0e206f9f6db92238a3f656b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2361d97a5f0899d588737d85b8e4a22a225a65391a36bc59fb769a985a3ed4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09141867079cfe16d678d1cb0ec980eae9d951851680e13f5392821bfd076abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7475998f1c2454f94f12cb2899e002fdb39ebb1b20109b1aa4248fc51a9d78cd"
    sha256 cellar: :any_skip_relocation, ventura:        "320b6d7024086e394f6d787c96b8fddd1952dcec22ca777bf5f46a66a2aa91fb"
    sha256 cellar: :any_skip_relocation, monterey:       "61d0bb4ad5c22bf0c6fa079534c6064eca12c31eddf7ce8e04fe0e5e18553848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4910b8484742d41cf89cb2e31ea658abbe8ae6f50fd6cde58c00715b6bfcc8"
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
