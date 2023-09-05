class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/v0.1.6.tar.gz"
  sha256 "abc06d3fcded2e0820c88d4e021cff1e59c2f23d4dd4494720d8ca3fb59fc70d"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1e40791a52188d527b08e77ee5fff0875f8fedc4dae5ab1af548ad226cca410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32450158220501c307e89a754263721bfe7416a02b1c2da4b1c88781861da910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d10a2fc62879e3b7fa949073fcfc0539e5be469624142b0bb6a01068dc6bd109"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba547903a7217af992c3f85a59f5d5487b068510f057bab0a2ebd6f5c47336a"
    sha256 cellar: :any_skip_relocation, monterey:       "e2012fd8b8d169419c99d646674288c8b83673f0b941eb730542530a4f12b638"
    sha256 cellar: :any_skip_relocation, big_sur:        "8244c3eb5eef4a8b0cb253996c98795d309f07f3ba79eadc8eb38be40c66641e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab4172cb356cbab29c9f4f859738ca71c209e6e12fc3e6145a99111bb23732ab"
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
