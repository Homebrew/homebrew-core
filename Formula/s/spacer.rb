class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/v0.2.tar.gz"
  sha256 "7dd19ca312661250f6ce47feaeb5ee50c17f72c0b92a9413a476d8b1445935e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98ee55387e89d038baf7a8ccbbe1928e48a6b5fdef74bb822b6123d83919a00d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9d085ed1de410b6edb0c7bc0a8fe6ed8ade426980044c34b2bfd19b165fc26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf447fbbb83edd83e69b937859554f1205f0877c52872f33b326886b9da58edb"
    sha256 cellar: :any_skip_relocation, ventura:        "c70d2c0137a0de2df6c8fd26f9892d6fe20cfa89eec8902f5e43381b7cb513e1"
    sha256 cellar: :any_skip_relocation, monterey:       "75080aa97f2fe5e01bbc757f07b5dce3255ba0576799bba46f3bb4011477a881"
    sha256 cellar: :any_skip_relocation, big_sur:        "96f71622a71d4ab1e00f9d7fd6aefbac790b5e16af59ec2ab627404040cb6123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226f2d51508a0a1f7d48d9f31108f63e30392d19b0a0b857cb0e212a956b991e"
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
