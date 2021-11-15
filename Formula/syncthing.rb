class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.18.4.tar.gz"
  sha256 "ec4947d4119f21b50f444a0eb1d054c24db30cde0ac8a95261c8f3d122da4453"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346d2196e29b00cd6359d179fdaef3e5238d1fc0d6cc1115f011140187284e5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ada03366791d1adffd7aa7cc39bf0bd339d261fcbd0fb05c6cdbb1d08853a4f1"
    sha256 cellar: :any_skip_relocation, monterey:       "82eb35ea1ab8f85d7cebc303fde24dc46dc04601d769bcd8fa5e894c3c60eef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b12aba3f84da38e22b4af29d81f1fb276e0bda32b84d3b63505a23d1308f7ea"
    sha256 cellar: :any_skip_relocation, catalina:       "e358de640d97698911111de9d0b1ddbb192badb7beadd8851e25fec472394f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c3963933f138b2f782fec71ade0c56b49be81025dcdb7785ddcd8b5786b75a"
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
