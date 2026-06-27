class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.13.0/tt-2.13.0-complete.tar.gz"
  sha256 "fa326995f1af587f4d1566c729fce982e24c7c353e40e740ef76d3ba1481bdc4"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "447398ea11b1ef5445d95f2057472ae3b270b191bd27c0b358340911bf6dda8f"
    sha256 cellar: :any,                 arm64_sequoia: "6e5df385f3ff7a6757f0d7469f3df23195a9c2f1a458219c9140be84693760ec"
    sha256 cellar: :any,                 arm64_sonoma:  "e2493d038f1d04aae3bc798efc088b09f5f190a61bcd05b6469b5e3e8ab64f11"
    sha256 cellar: :any,                 sonoma:        "39d6bbc3062abc72514b77f4f9048d35ffda16506f776074d03955f4e3189f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f21088502578dcebbe17c38d245316c4841dd98adcb56fb3274d35b163b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05db4eecd4a9da746e3909d3818169db958887d5224f9d5c982986e211cd746c"
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
