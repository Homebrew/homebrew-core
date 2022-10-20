class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/v0.1.5.tar.gz"
  sha256 "1e3d36b3892d241dfd5e9abd86ddb47f22e6837b89cf9ee44989d6c1271dda2b"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd93296a62b2ecd77ffc7a1dccf3796c432037f3cf014f161009c27016074050"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d9d148980dc49756443f738fbe8e39d247781c8ae1ee5f8891ef0b7d4263216"
    sha256 cellar: :any_skip_relocation, monterey:       "91cae699291e925c8ac3b0e2e3456a3bc8363429bb3ce45b22f7fd794b83ae57"
    sha256 cellar: :any_skip_relocation, big_sur:        "28608d5a2f111dce271d708bfff08791f0b7e78aaf33f3b5ac62fbebf57282c0"
    sha256 cellar: :any_skip_relocation, catalina:       "4d2dde370ee2f884d1e4329b37fad76b0b31522622e66de69ba83170bb14998d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c2f7acad2bdb500f44166c6ad4a7cf9ea8eb3c3f9f56d294d190e8af2338f0"
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
