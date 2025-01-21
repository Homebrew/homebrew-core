class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "bb6d16772ed0728f396d32066d391206420497a4f902071b0229790a8c844307"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0aa436898d307013552ed81f6b14b5ff3e11395f6a18f4335d0b1387e4e1b0e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02f43fcce93fe1020c8571578b9e8b2592712bbca3aa79becc067b9ffbafd359"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b5f8b001cac3e971cd56939061222aeec9916ff57b71645c5d68fcd05a654b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2560679670ba581bc0eec3656150f6ac3577882eb549d7c33a6ac8ff1d1e2e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e4175a87a9dcf622e05c47df7ab97a0b9f3eb459a4e83dcb3a314cab7b4d18b"
    sha256 cellar: :any_skip_relocation, ventura:        "8d8ff5696f93d0cfb8e07f90a484e1bce94847ecc7dd02a8de103a7dc0925188"
    sha256 cellar: :any_skip_relocation, monterey:       "ba015c8a9e89563116c24bdb064ae9af8459d3bdf07254969d66cd88f40c50b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6871bbb0204d11a5fe0dcb85deebe1e97adc240b99491dd0a2df8ffa397b7da3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "regex", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/tuc -e '[, ]+' -f 1,3", "a,b, c")
    assert_equal "ac\n", output
  end
end
