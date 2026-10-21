class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "724b874f11814d02bf08f4dc74d47251ef7ec5b93ecc855b663c2def8e1ccef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "593d4dc23f8bc5be85ccc1fda95a3f3910b7f881128b3331ee22a149e5ded48d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c26c3b949b6c1db2acbcbd91fe0dbbd89fe292c8367847b897d6db82c7c7c4a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddebf48048eb7b113ed4112da6c9cdf27a50022325f2cc4bd4a01de901fb75be"
    sha256 cellar: :any,                 arm64_linux:       "0ba9717ccf82f067dd7e763ba70376632efcc4a22a3dcc94a3ae8aa10a6a689c"
    sha256 cellar: :any,                 x86_64_linux:      "1dee35a21b7f68bedb917b947b7dffda69a0151658ae4d2345a6f0cacd31c6fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
