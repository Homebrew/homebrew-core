class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.6.0/tt-2.6.0-complete.tar.gz"
  sha256 "8e35cc01a370065173a05570ddf7f836697b6abc755b9ac97e2701ac629c3e5a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ba9e3ec5ad45259f22b7b246f2a6e8f85211af040245a42d390601e7e054f3b"
    sha256 cellar: :any,                 arm64_sonoma:  "4ceef4b9fcd2459a09847e800b02de33b5abd1f00e69c6a05ff52322fc9b6b19"
    sha256 cellar: :any,                 arm64_ventura: "872c56bbe437746cad541fe8e7912a1b66e35e45a842f419dc309eae356d2735"
    sha256                               sonoma:        "220ce8467d21a9d00d9232648a592d71c41ae122603f078d12e4fb13f55309b0"
    sha256                               ventura:       "73e309b75525c039cd1c372acef9e11205e34a331b2a69e36c0a1d292318314d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09bfacc5a6a48be5874a659f57e116c203fa41413539530f95d5f43e485a753b"
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
