class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/v1.20.2.tar.gz"
  sha256 "6733ae6947497ace959c56f7c491b785ec058c8592cfd9824bc37125d1f342d9"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da9258865621614125f5780beb36bed00c12ae01ca330cfbb5a88d08079bbb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce19a09023e19d6a391a06394602108ef673932677cc9d29e89fe2f8c70ffe9"
    sha256 cellar: :any_skip_relocation, monterey:       "198d4f646b6f2fa2620989c90af868067559323bbbeb75bc6d2106b300654627"
    sha256 cellar: :any_skip_relocation, big_sur:        "8177e19acc44cc79630dbfea13a5588a812b84d4fc6a64e4e130411f610c7d81"
    sha256 cellar: :any_skip_relocation, catalina:       "db79591ba3977314a98d3abe5cd7d4f1230d8769635999e0626caae91d405e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce89afeaa7f790eeaec69fd9716381b749d7bf65815ec9a7a2601ccdf9f5b5b"
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
