class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "fa2edae90c7999a6f667bba26a6c63c7165647f77c02c83860237c6d08ee4bbd"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f457929fa740e624e22f791e9742849d6d5d9d721c996112eee422b190fa7a5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24db7c82b827b4f85863004c039e3a2bd6d8953adf6e011701c095fdfdeb4b58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec7b59a5b5b3849eca6cddf5754255b3b60483d42a704ed36aac5e69944df59"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a3e05289eb59d91a0a4814f23177114e46bd253a03e6101f5f4fbfc7abac163"
    sha256 cellar: :any_skip_relocation, ventura:        "af64706f213f5d7c63be8fa456454565eaf250c64bdd7118fd8b5494d7e5e1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "136f66adf319361735931739c67d50028ed47c46d9b49998d67b83938b0134fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93595a690b5ba1244aa1d03dfd61ae56e5f7e180ad2b2d23330534bd618a69b6"
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
