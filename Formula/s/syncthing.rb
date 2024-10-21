class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "ae0b96744a61d30e5fe7a6054d984c2a488c389e0e9baad8a868a71871ed1444"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a85f5656a01e94f2ac7eca1f8ead14a69d90548b27e0973eaefe2a60fd8843fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3065353b287cc4df7e4e88437486535b84f742b7363c0c347158e5b9afab0c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45cfa0e466ee6b3bf852935e9a1ba9cc472e3ab407e19aba8b8eea63f17abef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "38549e5f62c84a341bf8a60851b2b18c41b579f6f1afe794523266ec74272b35"
    sha256 cellar: :any_skip_relocation, ventura:       "d9c85dd85fcc2a291894a27a471ca2fc9526cdf1ff41396c48575af42c04e8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cff04d2d05c4f6fe4d8e79a8d93bf93aeb923ac5dc6b89e3a39de53dded54d7"
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
