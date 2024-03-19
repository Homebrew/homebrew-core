class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.4.tar.gz"
  sha256 "65542335212f10703a8ace949b811744f96c1adaea6deed6d3d7399b9f398ecd"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "433d7ae0ca52dcc12ef2e6ca7ccbeee3bc948c92111b6b8cd91c1490401cc665"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d88d25893c3ba0628fbd5747fbbe81cce16a225da844d7a54f2175cbac49e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4563c7c970d8254c47d4b911bfcdd4ba616a3ac7932aa33cd1b781f968cf2a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9296a75f9dcce7ccf07c79f9812d523e27389f83fea556be3920b8756dbf54b8"
    sha256 cellar: :any_skip_relocation, ventura:        "0535d9c6f67b3bc2fdcc50681e5e8dea20ea6c93747746ed74b9d1a38d2cdc64"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc454ddd883b3eec7977242ce78a34cbdc0be248d41b5fcc140498198bf7ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bf5b5b17fef14c8549c929bc3da64431291c9766e1eb1b0d707272c42e765d"
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
