class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.11.4/tt-2.11.4-complete.tar.gz"
  sha256 "02235b6d699d07f2ef5d406af98db28a0418e2e2ecc08a9a36e1741808e94c42"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52bff0cf515a1153cd390ced9961c8d9bd29563879ec6c5ec610eadb90404a3f"
    sha256 cellar: :any,                 arm64_sequoia: "7020847e2b219bdec659f70ff27d29b03591e704dfae1c900598b1e2db274891"
    sha256 cellar: :any,                 arm64_sonoma:  "fdfce8bb5bdffaed8fe56c67731c97b88c8a5771d259ad9e0d5d7c96167e4cc9"
    sha256 cellar: :any,                 sonoma:        "75fdb655649b07819f0ad417d1dd229fbca45b943ee9f746cca6f0a54afa5a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "235f244b5326b340d1ea1211251ad54ffc5f6b2a0f06ff170e5d88b03e00a246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7595ac4484d04966db78be5bbe86e52c6caea396b3b3a2ffaf6cc094bb691b8a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "package/tt.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin/"tt", "completion")
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
