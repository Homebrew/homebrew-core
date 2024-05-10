class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.7.tar.gz"
  sha256 "26c57b75663fb892ea19f077124a2dcf89fbc1cf55bd9e94b5e0495af41c9ff2"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "273d82530ebc08d437256856c2a6df72da7279e24bccc1b41cfc03b9e5432d38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84a4f6de5068fa586c01637e77c3939a28ef984e740045d0a7fbbfba4c4d5131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50be8e475572c1d28e077df7274bfe0b66a06f44fdc3c76eaeb63a5521891d9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "52d8f6883dafbece727d249c9928ed3171292ef62f6350ddbb1e5a44e8ba9886"
    sha256 cellar: :any_skip_relocation, ventura:        "25b570919894690f64fc1a4a512aa6cf4acd84faf70527a8cfdc489ffdcb8b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe22895e9b0217bc12ebeefc56b8ff55d99973fb76313981e239ce342bd4155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34f1ee5af46151fe294ceb93ad76c72beb408cc9bb624a022fba07ce98926259"
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
