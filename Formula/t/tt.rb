class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.15.2/tt-2.15.2-complete.tar.gz"
  sha256 "8db35fb323fa84f3d83914ed2461e40604171c4793b496d6dfc804618e8d0fac"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d14326a0bf7e84cfd7013cd8330c77eed1b33929822eac06cc8ab0ac51d96eff"
    sha256 cellar: :any, arm64_tahoe:       "aec53a3f79902fac47d7b21d082da1e78652c8056a9c894dfaadcf2263f6e34d"
    sha256 cellar: :any, arm64_sequoia:     "9cd7840ce4cb09ecabe750c326e49bca690c8719ffc2dc807eed0fdd64e534ea"
    sha256 cellar: :any, arm64_linux:       "018b2bdade45ff1f7bde29c0dd56328900ee1bf988e70c114fceb205948f5c50"
    sha256 cellar: :any, x86_64_linux:      "4abffd12a755b9c4054cae7437dc368db7cc05183e7d58f8c6be84c2c5a0df53"
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

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "go", "mod", "download", "-C", "cli/cartridge/third_party/cartridge-cli"
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
