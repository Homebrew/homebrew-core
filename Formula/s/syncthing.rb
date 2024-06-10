class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.8.tar.gz"
  sha256 "39069757d23dcee6d46a67935b6d0e1eb54a63698b9e82bc7e5d71c2a52e2659"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5afe94058d1e36e0e7f2d92d4838638990cd941baf100ed85fb92e501c88ca9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d450173d4a533566927b53329cf81a1a265673d1c1d0063dfe3e86c7670a98d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6505ae776f4672d3cad72cdcc6ab09cb5f20cee65952c51ab36a31507692dfc"
    sha256 cellar: :any_skip_relocation, sonoma:         "440c3ea2fab89ff0cee7429d4932ab37886f1e117e4b57c0f01357fe28c0bbf7"
    sha256 cellar: :any_skip_relocation, ventura:        "51041779d9d26e0dae0a6e2fcb7d29eee38a73ee43143d66cc6c6fa19c43f311"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f02807bbce8220423073499bbbb730b847813556974065660dd0dcafeb5055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63dc4759e6566c51f615d54e8e3da266a90882b6fe9db0b662b3b12761de93c"
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
