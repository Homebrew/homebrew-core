class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.1.0/tt-1.1.0-complete.tar.gz"
  sha256 "fb90eb25663ef4d878391299b145f55abecd2be0d504df601f46a25b979a1b7f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a01cd8ed6bedd867345d8ba94a787fa1884162441bf744cb5c6eca0a03a719dd"
    sha256 cellar: :any,                 arm64_monterey: "7c7513094f0d60d41d3e5fa74925faf922105e89465de16c5d2657d90f44ba06"
    sha256 cellar: :any,                 arm64_big_sur:  "8622255b5d1d20f4bd505bec4a2d7e5579c892e8599bab4f83f6a8f2427a5b91"
    sha256                               ventura:        "a280e8635b63888b18fc72091c9e46578b652da07e359b589a764adebe27898f"
    sha256                               monterey:       "00f20d247af8b2ef8d05cd5200e35aaeedf178610d153ba40a36391f07ee14bc"
    sha256                               big_sur:        "054a6215f0290388aeaaaf4a8d382cfda52b2762e4bc08322979ac1a554967c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533aabea76cd2421502492c68ceffe2928991618339f733b17d7863a07530e00"
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
