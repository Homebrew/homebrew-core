class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.12.0/tt-2.12.0-complete.tar.gz"
  sha256 "6f1faff3b915dfa218da3604e9fb64bcefd0458f4bd481e185466c9fd2fffd29"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d53aa207f7ca4a6e51f9f820693f38fe9b2c4b8d69dedb74aff1d5cf02f05ebe"
    sha256 cellar: :any,                 arm64_sequoia: "c09ddafbc0b5a59a8f4b05c194d1a5d2f84ff105aff379ead80025aaa76fcde1"
    sha256 cellar: :any,                 arm64_sonoma:  "9b81d4af15274939f3b3b7a7a2c4f13222d6c824f28149817ced0e87b6ec3dea"
    sha256 cellar: :any,                 sonoma:        "fdc2c8401579792eaa291bd25fb650053c3af2ebf5f402b361e2e7aad06049b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2746cbecabd336b05302fb3d97b583cc96d874b4c0891818dbd293107df3025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "159de42264f042cbffb7032e01c7427c5d6f81361d929b811e9fd139404cfbc8"
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
