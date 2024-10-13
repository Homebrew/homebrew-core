class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.4.0/tt-2.4.0-complete.tar.gz"
  sha256 "9b099f4d4b376b1043759ee38c6319a9221bd2005c14d909cc7977f83a58d05e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ef6dfff15ed6f527dc363848f74c1ce20a9985b56ff68c610b26f83e7f3db6b7"
    sha256 cellar: :any,                 arm64_sonoma:   "0a115329895d87dc0a1d258ec02bb76b16b9a2bc13a1814f8ca3471fbaac1fc0"
    sha256 cellar: :any,                 arm64_ventura:  "56e548e607543f6db9108a2ad1c44ab47e3c801cb214ca8074276a3468babc91"
    sha256 cellar: :any,                 arm64_monterey: "ff07f8f970e305a29a86aa237974e0cc6f601f3aef61f89dceb1536ec695fa3a"
    sha256                               sonoma:         "fd99a6ee28165c128044a8f3cafa6713e2483d82f592fcd49c9f12c342b0af8c"
    sha256                               ventura:        "27eaf4efc26d6cc10a2a06185d783000b13084d83c8c1e304e39fd7008cc98b9"
    sha256                               monterey:       "ae61e09a62415b9257aa2cc62eb83c28ceb9ad6d40c663e9cd4dbdf15cebf27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7729e3f23629093a9c47c22c37a14815a957765c2c912c915859fd5a5d20890"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
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
