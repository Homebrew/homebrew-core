class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.11.5/tt-2.11.5-complete.tar.gz"
  sha256 "b3742864ca7ed55651475f32450f799d7c95c0cb6ca9faff95fe58dbe116d288"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b81fcc3dc1255ef62594f41242413ead9141bd4969a2e57c568bb9bc25fdf60d"
    sha256 cellar: :any,                 arm64_sequoia: "22da5fad14af1df2cf6ab910843113980235cbdec4dd0af35d20b66bd83d5a47"
    sha256 cellar: :any,                 arm64_sonoma:  "14767ece9c248e8a37eecdc6cd2876d9c6b7272227a517eb32132723734c4f53"
    sha256 cellar: :any,                 sonoma:        "53fe5f9cac578ebc815974a82242256876631658fdaec5f4646d941f63389e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9028cd07544c5e50738f9f7ed16acbd3dfa58f3b2ce929141c1b8011437cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40cd1f13655f08289436d1529f63b060d3f0fbbacadbcb30e26bd2afe1d1c10b"
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
