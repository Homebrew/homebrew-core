class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "177792c697f61fc25f02d8fc8923dfc57ebb35753bd92c8d32a73d553446d117"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85aabc55d93a78cfc1b24bfd4b9d9c2f06f9f3637055c4f18e5e1f25be377f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0589bc25280444f9b7ea7f408f8fa65c3754514e76b7d347b9b4e458f797f563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde17cbd25680d06bb6dc449550760672cb9bc5e48cfb40087eb8efe41a8bb58"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dee0b629e6e9df3c4ff45db53adc3e1f3ec5cb32c1819c08441f63086dfab36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cceacdb7daa79ac7b06042d0d673d85f3486d26e0f581e35e76824799753155f"
    sha256 cellar: :any,                 x86_64_linux:  "78fda17b667f921407723292a582595086614a19ac033bf64dea0412333ce952"
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
    run [opt_bin/"syncthing", "--no-browser", "--no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}/syncthing version")
    system bin/"syncthing", "generate"
  end
end
