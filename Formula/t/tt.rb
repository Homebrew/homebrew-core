class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.15.2/tt-2.15.2-complete.tar.gz"
  sha256 "8db35fb323fa84f3d83914ed2461e40604171c4793b496d6dfc804618e8d0fac"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3669ea46808a2a9c3d3db148b56a15089d61fe02e25e4d322609e3084600bded"
    sha256 cellar: :any, arm64_tahoe:       "ac3d6433c925c4089b4a5a69cd54129253e4bcc28a5e4e3418c44eee20ad0a45"
    sha256 cellar: :any, arm64_sequoia:     "4a5842f60358d1e95d916eb522124be14c52ec46a11b9d0f5f41300fc320556a"
    sha256 cellar: :any, arm64_linux:       "3475f74b1c301ea8f3821814c21b80c6cb844021db8c15294c8ce0c919ca55e2"
    sha256 cellar: :any, x86_64_linux:      "b0af315bd274c0cbf15398ae299de60f97288ebd00fa022a53cda5f6e84066d5"
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

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "go", "mod", "download", "-C", "cli/cartridge/third_party/cartridge-cli"
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
