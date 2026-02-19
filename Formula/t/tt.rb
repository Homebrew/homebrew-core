class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.11.1/tt-2.11.1-complete.tar.gz"
  sha256 "50cf1de2105cccf824abdd4eeafc47510072fcffd0dc9e7664f984e037e45c2b"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a24cd3cd17e5e04054b8224c71138aa625188adaccf525b2bc15eee8ccbfb120"
    sha256 cellar: :any,                 arm64_sequoia: "75b945cec579d1099581bef50080ec29536357fdb1e34e44ec2eebed60b6cdee"
    sha256 cellar: :any,                 arm64_sonoma:  "80cec771281aa429d566d9a16d079762f4ffdabe5adc367a3a32f23bd8f5ca52"
    sha256 cellar: :any,                 sonoma:        "c3898f14c9d1ab7454135dfab05dbb8fbc157efdc63b8d29f2f3f932d20100d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeadc59d3f15770f9fd40620b2c09495382b7fc4537d6d3ac185c7c738b8b991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875563b38b8763e04e86d99c36f822fbeab1ea712babcde0bad32008204585c1"
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
