class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.1.1/tt-1.1.1-complete.tar.gz"
  sha256 "846a81b3320907ae6c74c1cc5180f4fa95fe75369c304c0512a5dad94da0e795"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf37b29dc07a515a44872508cb3b42f53f54feb101464ecdaf66d6df5b812598"
    sha256 cellar: :any,                 arm64_monterey: "a34023bd4fb0b6b4d96e41f2ce2a73db0e22729bd830f5edeb7779337ae0efe3"
    sha256 cellar: :any,                 arm64_big_sur:  "e83664d42f912521a8e280ea65396cede5725e57042b867d321a8a976546cfea"
    sha256                               ventura:        "7300e685c0fb2637c25d829e9bbb2ef4505bf02db23b3f1b4738eb514df061b7"
    sha256                               monterey:       "a25f899a1bfd7f62f4dfe473e8c99244d0085a79656b484f7c1119cada6ae0cc"
    sha256                               big_sur:        "daee6a93262e97d504828b881e1c0566e2158893871e1ec694c142dddb35f173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9413566ebd6bfe8b3ffadfce38abba557e0677a1824691cdbe2c6b292252e7e2"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
