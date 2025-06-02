class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.13.2.tar.gz"
  sha256 "afe8887b64c4da6e5f33535d02ad4e1fe75c536a55d63291622b4b339522d138"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4530789e51dc8c8dd49ebcc833156206f221b7f2f8128ccbbbf45ad1e04bb88b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096ca704f5351ff2bcf266995070c381f65042f4348b08b6ec1cbd4fa4211488"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "866f22cdc9c573ecb5a7d394e5b728ca660bc34e1129f3b970eec946015916e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f03798d05ce72ccce6b6ae4591c6bcbcd48afe4a1c9296998666de69b8ab037"
    sha256 cellar: :any_skip_relocation, ventura:       "e0c9f8f7d9ec109da08fff90c25e4cd5329384bd130c1c7c2222e5153b7e321a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb4b8c43695aefa2e3261570b6e96754d3d2c435d9d0fcad89a148f09b1a6198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13b82f0928bc39fefe5e9a4ec5445bf4d8035c5a43853739e0353903609d74d"
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
