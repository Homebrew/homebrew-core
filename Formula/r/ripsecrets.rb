class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "d230246a517f2c4cc9e719633b5c2fe771d7251bac25257f3b927e14fc408071"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8509e834f1ef8f9d72071ffbe9ea369f9e0806f3543848984f0ab6ccdb66c8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e149bd76eb597c10c6ce2ef09297ad024214b652a0f22c1e8c4e433da606e426"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bab93d34726fe470b2b110f95f344702066dfea7b81711c6267dd2608c91bd7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca82959fc0f6457931e6dca1b364ff2016ee331739815452bcc75b9241028192"
    sha256 cellar: :any_skip_relocation, ventura:       "b0686715c0fefea8ae7c6b1a329904f90f3d522cac0a2eb80b6e9f187e4fa4d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff4ae371281630bdaf268d9d2c52cb4ea2e5dae1ee13b4ef2e1ecb94572834e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7a44e8f93b378dede7a94716d4d494927b8226954d824107e435bf6ce24630"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/ripsecrets-*/out"].first
    bash_completion.install "#{out_dir}/ripsecrets.bash" => "ripsecrets"
    fish_completion.install "#{out_dir}/ripsecrets.fish"
    zsh_completion.install "#{out_dir}/_ripsecrets"
    man1.install "#{out_dir}/ripsecrets.1"
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath/"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system bin/"ripsecrets", (testpath/"test.txt")
  end
end
