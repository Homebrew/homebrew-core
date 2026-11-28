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
    rebuild 1
    manifest_sha256 "f759a3977ff97aefd12ace4c803fad9db8972aec621b2b4e98d10871a3982959"
    sha256 cellar: :any, arm64_golden_gate: "dcf2c474052ec2bbf472c94eed3550fc6109ad9caeb3328eaf65bbc4fe92c496"
    sha256 cellar: :any, arm64_tahoe:       "b318d909fd2f6c387d24dcb15bbc9d3dff7d304aaba3a2cfcf0e93401a262320"
    sha256 cellar: :any, arm64_sequoia:     "f9f69299289e1be39ef23ad2a9b43e4243b5f7a627ab6c85c69731305f25f2c8"
    sha256 cellar: :any, arm64_linux:       "77d59056b320a3e4a3630f2868a9015864e51237fc604e48ff48fac35a01ccca"
    sha256 cellar: :any, x86_64_linux:      "d990fdcdfd3333a0d962d236901d535af753aa9edf947a315e731821539fdfa0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

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

    # Avoid bash completion being manually sourced due to
    # https://docs.brew.sh/Shell-Completion#bash
    generate_completions_from_executable(bin/"tt", "completion")
    (share/"bash-completion/completions").install bash_completion.children
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
