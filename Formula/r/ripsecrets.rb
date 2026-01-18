class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "786c1b7555c1f9562d7eb3994d932445ab869791be65bc77b8bd1fbbae3890b8"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9ca11d40867606927111bf7d1f076284b38be676431935508fca57bfe9c961f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be229f02f517c7c9f809999ab00daee0b4650f7bf6eab3e31132c4dacc7c1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da96cf200c77669126e46472b94098c5e14cad9d75eb648a6fc05feafb754946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7c30db103b32ff7a4b8ed285a9aa61dd648cd0fb8d2fd30b165930ffa193b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "58ce1e4409a7648607e32cfb9a1a43b5b25656f83d9570dc66137bd97a7971ef"
    sha256 cellar: :any_skip_relocation, ventura:       "5d8a3bf678aa0016c6c28511bd19b7689248dca8291169bc2e2fbe97cfe486ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b5fcd9d6cb13c93553bdca9e23f0b1b2c0d5de7dbcbe082ab1537edf610bd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb68c8ad22e92b64ce40f6380978572e9857d8e13fdba1e9efbbb0c8a0e004a"
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
