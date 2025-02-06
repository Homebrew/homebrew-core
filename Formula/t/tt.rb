class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.7.0/tt-2.7.0-complete.tar.gz"
  sha256 "05afbe400da1459ccac218750d354f7f2c362e995b65f771d537ccb21abdeac3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26ed5dbb8e03e8bfc9e7a08351554c814afcd7388c28ee623a45b901f2f16328"
    sha256 cellar: :any,                 arm64_sonoma:  "348a4e516cfb09283edace39503219a8bf84bc109808df76149d30472bf154bf"
    sha256 cellar: :any,                 arm64_ventura: "3349d4003dd186905a14b65864e7715328486ff40ec5076fec6047fa5488142d"
    sha256                               sonoma:        "4678e3aa80b432beb59db63f818f6138ac2fb1d6366fa81a38eb2e64ec2ca056"
    sha256                               ventura:       "b1b73a7bbe06c999e8dfa98fba773b150d6d23a1d2d7111bf8e73837c8efc7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3feed242b0fa7b383135ac27668051ec9a40858a990692b786be43eea3c975ae"
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
