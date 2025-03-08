class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.10.7.tar.gz"
  sha256 "39a490a394a0ce975b1144c775acb1bb53e29383cd0ebf023ed7c2b66ad96d88"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a62b2e4dedb1d02c1eb15cb6aa4f8777bee355c135b20d30bcd1baf9eab6a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f5199cae5e890970ea5a24c324123c592c699c311a4635cbd499f9cd4a18a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49c9d37a81fefe83af9862b07d8e07d9bd1f19dd83a0c373c33bbcf89ce21c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "eab0090a058d9a9a2606bbc1dd8207a6b68da8b7d28cbb0b175c4c222bf3cb28"
    sha256 cellar: :any_skip_relocation, ventura:       "1eb5d839238da37a211eab6fc62b95392d98b3ab4acaefe45d0a34f2e3387fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a0adbed8534d220392a5ba45e7ce917dad4c66645c809ac1f48a33ebb455087"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
