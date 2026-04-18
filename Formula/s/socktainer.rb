class Socktainer < Formula
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://socktainer.github.io"
  url "https://github.com/socktainer/socktainer/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "12fb7f612402afa66a49adeeca480b89ca6659dda59ad9417bb4abd12a9c634e"
  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :tahoe
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
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
    # Apple container cannot be run in a test environment, so we test for failure path instead.
    assert_match(/apiserver is not running/i,
                 shell_output("#{Formula["container"].opt_bin}/container system status", 1))

    # Asserts that the compatibility checker works as expected.
    assert_match "Apple Container compatibility check failed",
                 shell_output("#{bin}/socktainer --check-compatibility", 1)
  end
end
