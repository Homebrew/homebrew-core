class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/v0.1.5.tar.gz"
  sha256 "1e3d36b3892d241dfd5e9abd86ddb47f22e6837b89cf9ee44989d6c1271dda2b"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "875a7077129c2c6e616546710c84ce9d0600bea2d5175968df4979ec0bb0353b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5f6de692f2b9894e71c816eb109a14941c34ada55bac9ccc4b9091e05138b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc03d9085c82a004ee252cd92ad9ab2a334538b7dc9a28532e275f38a8d9c462"
    sha256 cellar: :any_skip_relocation, ventura:        "dd27d00c1e0fe8c14388b4a45b112c22e15ef21cc0755698ce24da4392122f58"
    sha256 cellar: :any_skip_relocation, monterey:       "ba619b6c9b0dddc4a985118e52e68606e38d1f26d59bd6a31c3a352345fa89cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d80f09f4d00ba3b12b3c7c1219f9249ea2d10c5641bec3eb3cbc96971ec4b019"
    sha256 cellar: :any_skip_relocation, catalina:       "e82297cfa8311cd174c61ef61250db3dd5de6f4d5bd7098f7af2440fd7dffc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd2c8ef43fa011717bc5654bb257bb45b1d27321bd3dcdf170d4338ad5c80a0a"
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
