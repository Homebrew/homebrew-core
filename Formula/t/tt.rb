class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.10.1/tt-2.10.1-complete.tar.gz"
  sha256 "7641a99dd22a46d99c8dacf2360e5e30ef8a7daa2c122880d19469c7488263bc"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f772b8c7eee090e48a6a1c39e911e15a4d219cb730f0beab42b6656222b7a6a"
    sha256 cellar: :any,                 arm64_sonoma:  "8920683e9b2b0f43306dbe0a139e348014eadc321df5c129f874452a8d349407"
    sha256 cellar: :any,                 arm64_ventura: "9f28c89f222076fbccf82996393333459193aeec4bc14ec1a5b4c0e8b6d06996"
    sha256                               sonoma:        "b2feee12acd3fbdadd19ded4a2f85241ed57db30f74a3c3473431a44014f8c62"
    sha256                               ventura:       "32bbbe7b26bbd3087f86f0c4724ba26cafb3360b153104ee9ec831bceacc1658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07802db2c90ee5352aa60201375fa9a35555c439753ce29b7a2e397c6dbfaacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eff6a9f4c6073b503b8371b0d05ef31883d4b25c6c2110042bf876a8dc3cba0"
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
