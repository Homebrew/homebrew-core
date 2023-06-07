class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.23.5.tar.gz"
  sha256 "d87f02b3e970c0f08c59166851b40ee5c647efcb2d70b5f0410416987cd42294"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5bc5fb3cc459e87d89c1a80659028b1a14b7a69a799ad2fef751db8e81d40a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a2de90ed0d2047be53f0f1a6aafc94cddbdc0f57506076866fdf9fa6bb5729"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc256c874c74c88f5884853874f23e8d12355312e07876b79ebbb98621ce3026"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4edcc4f47a779d72d422c2a4d267714cabdbce5e3ebf263c088c6930da4a51"
    sha256 cellar: :any_skip_relocation, monterey:       "84d20e85d18f96f349fd37d99fbff99a14154622c04decd522d57736d33eab07"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a6e79f8dd2a54fb7ac1d7b08ad6baa675fa2df022a2c98afea75af520436b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fef00ea3b9c22af20508adf429bd6f8719bf2fbfe46fc5112963f9a4a8875fb"
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
