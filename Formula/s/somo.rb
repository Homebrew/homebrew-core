class Somo < Formula
  desc "Human-friendly alternative to netstat for socket and port monitoring"
  homepage "https://github.com/theopfr/somo"
  url "https://github.com/theopfr/somo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "15b2644ee13e70d9c2ecd1bc3171e1722ef609484e4bac708d1b7d5b0d129a66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09f8b7e68a7244f5e8c22130a6d8295632f40b0ba514b3ca17ee0e402d0631d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff92fa583e36ab6ff1bf876f7b03497152930ca15512bcaae416bd51c4f66810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "401e1c65bcd88e3a6f022fd411b36b95c164d139dd0e3a7252fd52c1e8a7accf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bfcf91e8871572764d63c09923debc006b37a59f08d543416a02cf4eb32d296"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b8ad9fb541d090281c5a01bac8dfc5abccc711f3462bf5908f7ac2d56d436a"
    sha256 cellar: :any_skip_relocation, ventura:       "bce7fa3b61ba0645aa6e9caecef55247213fb6a8e5e282593a96dcf6ea0a5305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d04b3983ed5b9d96692c803f76c90d2c9ec8b113cffda39a93b38a987c376e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3297f2a8d8b3c350337e112ab462e2f5748b0fbdf0cfbc4619c4191f1f64d25"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    TCPServer.open("localhost", port) do |_server|
      output = JSON.parse(shell_output("#{bin}/somo --json --port #{port}"))
      assert_equal port.to_s, output.first["local_port"]
    end
  end
end
