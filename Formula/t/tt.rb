class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.9.0/tt-2.9.0-complete.tar.gz"
  sha256 "51a1c968e581f70be03552deff7cfd039584105795406f549e20a8796765b3fe"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd11b030c9ed1dfab1a67123f8e3b1eaf8932051f21f95ee95d5ca1f9021e97d"
    sha256 cellar: :any,                 arm64_sonoma:  "086fe172e04e62c53b378cb5daac8d221350310b2b04868c7a34219c4a7bed2e"
    sha256 cellar: :any,                 arm64_ventura: "169dca6aefecde284f27e645231ab4fe62a8e5a48bc62b833cfb346f58187d9f"
    sha256                               sonoma:        "c3768fa71b0bf4ad22ea1c68e5c68f365ef52ed4e222cd679b6fac6a6be7556c"
    sha256                               ventura:       "1ad0c8088eb44e175cf81b0b809cf81145eb6b735ac5b231baee7341f9ab2c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ea887a9ddd1690f43052cef92c96b55d535742a0fd38c2909a688978cf6bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0132d50e67199831ffa3ebfca8319db3e0d2737f7e37bf597b11ea2c0967d0d2"
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

    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
