class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.7.tar.gz"
  sha256 "cc36d6244590f0eeaa1df6f465b617dd7fdbee3dae434d55b272b25580f6e53b"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a880b1b78830b96d27e32a45dd50c63b08e6ef1118196da37c68afe2f94d0471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91a79831d8b81a23076982861178f810fefac6b16df7614e238a612dd5fb6402"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0ceeaf58a638c4a3f78c63822595c8e514c1dd31689be62ba1cac49a1f71ef0"
    sha256 cellar: :any_skip_relocation, ventura:        "2873431e9607613de4e81f29d4351b42572f8c3e905c738d8c0c760f8e18d5b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0cb043a54e301be125f8da08310a2ba6d67aabde025988bc8536c0bc19dbac41"
    sha256 cellar: :any_skip_relocation, big_sur:        "90c37777b59c9af9e22ca3fac8f2cad3024431cd0ad27b6c08219f7d6b742005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb749e45be52243597478ad2b59cdfb4fcebe36b3ef08d8aa9ac3b0b4054f51"
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
