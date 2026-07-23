class Socktainer < Formula
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://socktainer.github.io"
  url "https://github.com/socktainer/socktainer/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "6af4809d4073e3c4c5874b05b1aa624ff009252888af989e00d90db9a7d34dff"
  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "5a8e8a7566a585a55f0fe00d39b48a4451c3c18707e0b9901ea428ac940a07d9"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :tahoe

  uses_from_macos "swift" => :build

  def install
    with_env(BUILD_VERSION: version) do
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
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
