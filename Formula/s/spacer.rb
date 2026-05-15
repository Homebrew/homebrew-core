class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "310b08c538c04bae779a1c4786430e974801e8880a4c5256dc0877bc82b61af0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ad1d7ef330ecff134c5087b76e6b5855a09e09dd39948a3de6c89f9db7bdc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44c96456fb68e660e0904708225cdec6910607192d425dc5b3e1ccfda3eb1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8588858045ca5046703dc2a0ad1973f47baeee8ab1f22559cd4bdc30aa4905e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b23b6de05f16c8231f4bfddf0a21fe48b76d6b894f5eb4f11caff5e9d68d3b09"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33bc9a0c463d9864f5aad7319f9f751a817376cb492f8d2887377be1a512dbc"
    sha256 cellar: :any_skip_relocation, ventura:       "1aea63a3358c379050d554e6897d1500a3fb10731ed56bf433bf607336fb61dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "772ffb42357d2155e5e8fbbb3aee2c49e117f5b20c896a0ef2e7f3629e8ce176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea85a47a83223e6907e372483ba50eca0b34643c9f8fec558fe2f605692f2e9c"
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
