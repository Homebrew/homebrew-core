class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.9.1/tt-2.9.1-complete.tar.gz"
  sha256 "c2db35772470cdfba8b2e1cba06391d848cfec3c50163e635be305aedd23c04a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d04aa04e9bed0b14ad572a06872d32e48c2df523e38221943908806d0ef0140"
    sha256 cellar: :any,                 arm64_sonoma:  "b7bfef5b73cf784b28eea0ff9e2cadc4e4d66f3caa8518d85362f01de5d2a596"
    sha256 cellar: :any,                 arm64_ventura: "17e36ad39cc6eff36ba4417a514e33b899b9d2cfac9beadb6256d21a9a827793"
    sha256                               sonoma:        "eb3ed8f61cc6b844e6728ad12a202768352d1be5b46a0e4be684d54e8d145724"
    sha256                               ventura:       "5f3bf271f86d10e3082cfaa3208e919ff1d60bd14966b9fb497d13c7c3007ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49e0d720c0028f079bbdd709b9b2737bc821e768fb5144952c308cd997f56d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e685ed345c8e6fe62a1d357fdade38e242354eab0842ac0152723baaf74168c"
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
