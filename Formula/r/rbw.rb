class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.10.0.tar.gz"
  sha256 "d0c29e5b6e7ffb35b61b9e1775b31da8e88f136dd93451ccd2478057195f4d15"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7de507179b87169ecd182e9718f043caa42dd37aef9421ab2511aa88ba0a0bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd990481a98f2253fa262b6462517f7315697abf2bd3481829ca0a3ab1fb53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbcfcf95b200576029e4bd5901243e979deee5896ae62b6d22fc9c09a9e20202"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9a536f29df29164b3a3bc58af9a171588e01a1abca7ccd9b391251ae7600386"
    sha256 cellar: :any_skip_relocation, ventura:        "bf41b2d04c144a54b8ab5238b935d1b2b7246eccdbac22848de2a64422c2ccc1"
    sha256 cellar: :any_skip_relocation, monterey:       "88e3dadf0419cce99aabe766c0446898c866276b4002dc2a19ee783bb42e8018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a413138f8776d4ca12b08d4bc96d813eae9de1d644da0bb200c977e6deb7fb89"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
