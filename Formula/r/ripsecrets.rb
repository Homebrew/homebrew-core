class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/v0.1.7.tar.gz"
  sha256 "12e1dfcd217bba34f74fd639d1a8de7dcf93ff2ae69398e093dfd794811db3ca"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8cd8cb33cd39e9fbd569d78216b9a22f72dec7eeabbcfc14b38b96b63b23ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d8356fc7e86f2b176eb1c7ea5b8c104d0f68ae6b96b0b4f6431fd94151c4c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5dc8e5a51ebb4de784a6b095996df4441de7689ab3fb91949225619ceb7b7ec"
    sha256 cellar: :any_skip_relocation, ventura:        "4855d68e9b91f38a55e452bdd73c77dcfa55c542039204ea313b7fb54b803f16"
    sha256 cellar: :any_skip_relocation, monterey:       "4a280b78f13e1a6046ec946d115405897683e76499c43824b4f9b79bd4cf90d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e94ca4ed4cfdfa7352728a4eb895b84c055a6d7998ff5c2d81a83b2d6bceb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8f45e8832d729204966a87b224c5c89e9d571d21f7df763c9e28c8117fee15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath/"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system "#{bin}/ripsecrets", (testpath/"test.txt")
  end
end
