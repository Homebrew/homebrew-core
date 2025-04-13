class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "56e10af707cb060d6974559d3464e2ba0cb60db70d4e9d81e961ba88058b2925"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef7c78d2acc3602cdb46a27796ac03606fc237761f6390866a8d47eb2973dff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1b47b321f4163d43c930df2f0a8826f627a6976296e90097d6cc7d66168f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47cfb84321dbf61d82f44bd6a184861380297d3f692950f7224d9689386d103e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf34987b91b26af106233a25fbaaebf94a872e62794f686d227a1e6979659307"
    sha256 cellar: :any_skip_relocation, ventura:       "5c9f8b395088c5c2635f9f39d2efa4b517365e1469e823c9e75c23d77ada6802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3d35829b4c3ce86cb06c462b193d5c153d27408151578435abcc53b7c5d0ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5f27c262e2a2d6dd9c9bb69d59244b02088303de9080d275db287741c24182"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end
