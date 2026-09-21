class Socktainer < Formula
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://socktainer.github.io"
  url "https://github.com/socktainer/socktainer/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6cc0c5c6356d72075f3bd4f9e116e52937d1dd8822ad623e2d0df97f4601e59e"
  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c33cf165f8e4de61aee8968eed0473cecb179d37578b64bd9996d57e82df5ebd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fa403a38b8f0214044f8333797c5cd35c82091568d2af61adf7c7690182aa8d"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :tahoe

  uses_from_macos "swift" => :build

  # Support apple container >1.2
  patch do
    url "https://github.com/socktainer/socktainer/commit/f0bb750256fa23648f2f240625f6ef179e80e660.patch?full_index=1"
    sha256 "395a690867b55e5f8bb262c3444076d67bb836b6303470327040d56c79396c07"
    type :backport
    resolves "https://github.com/socktainer/socktainer/issues/181"
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
