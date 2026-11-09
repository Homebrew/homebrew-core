class Socktainer < Formula
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://socktainer.github.io"
  url "https://github.com/socktainer/socktainer/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "13c4197c0a25733aa9d7ea4ddb6042176d7060a014075edb054f708de5647c0a"
  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "47618ef2dde1e57376c3a2ab6fef17cdfbf238b8ebe51616dd22e61160684171"
    sha256 arm64_tahoe:       "7e0ea9616079789a3684bb4d959c9e1a8ed03d51dde4cf076040d7caef2f3b1f"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :tahoe

  uses_from_macos "swift" => :build

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    with_env(BUILD_VERSION: version.to_s) do
      system "swift", "build", *std_swift_args
    end
    bin.install ".build/release/socktainer"
    (var/"run/socktainer").mkpath
  end

  def caveats
    <<~EOS
      Socktainer exposes a Docker-compatible REST API. You can connect any tools you installed for Docker daemon.

      To connect it to your tools, add the following to ~/.bash_profile or ~/.zshrc:
        export DOCKER_HOST=unix://#{var}/run/socktainer/.socktainer/container.sock
    EOS
  end

  service do
    run [opt_bin/"socktainer"]
    keep_alive true
    environment_variables HOME: var/"run/socktainer", PATH: std_service_path_env
    log_path var/"log/socktainer.log"
    error_log_path var/"log/socktainer-error.log"
  end

  test do
    # Apple container cannot be run in a test environment, so we use version check.
    assert_match version.to_s, shell_output("#{bin}/socktainer --version")
  end
end
