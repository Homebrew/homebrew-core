class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "65c14dde2e90827c8b91353824cece614e1e645657ee3200eafa13165f27a3da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c788e3391fe8dd06b5a6f9cf80819d2fe273aa582562d38dea99bc5ba1736ba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9446270b0bed14747c41b85a257fe6ddbf04ef4b8cecf04f56e7a22d8ea720f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03afc1903f2a05f2b01857e66ab3577f9c1f8dd8a6f915f27670fd928007fe76"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7fbeb2d5cb59acbb8686dc0bee23948df426a75f82d5844f3cda320a6de7da6"
    sha256 cellar: :any_skip_relocation, ventura:       "0cc6076dccf36226e875aeff6d1adbed3f52eee43100ad2d1a388def333ed41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba9b36ef4b0e1c2b1ba5df6e540e95ea81174644e401205826e96a4a9e38546"
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
