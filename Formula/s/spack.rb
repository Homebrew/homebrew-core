class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "ddb8220c46743e45c9484622370a1e17e193acba6a43230868c2dbc717e88b56"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6173f977d3891104cb46ee50c4bc837cf7b92661af6183b62b0ec83464d8ae83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6173f977d3891104cb46ee50c4bc837cf7b92661af6183b62b0ec83464d8ae83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6173f977d3891104cb46ee50c4bc837cf7b92661af6183b62b0ec83464d8ae83"
    sha256 cellar: :any_skip_relocation, sonoma:        "c682f2cd78501749a964b8746a96323360756716b49f328749e112083c458628"
    sha256 cellar: :any_skip_relocation, ventura:       "c682f2cd78501749a964b8746a96323360756716b49f328749e112083c458628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64db88c47bf810db166550726a6f6d2f9d22ba8d69c5d2674f897e3d5c65a016"
  end

  uses_from_macos "python"

  def install
    rm Dir["bin/*.bat", "bin/*.ps1", "bin/haspywin.py"] # Remove Windows files.
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    system bin/"spack", "compiler", "find"
    expected = OS.mac? ? "clang" : "gcc"
    assert_match expected, shell_output("#{bin}/spack compiler list")
  end
end
