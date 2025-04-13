class Toml2json < Formula
  desc "Convert TOML to JSON"
  homepage "https://github.com/woodruffw/toml2json"
  url "https://github.com/woodruffw/toml2json/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d32aceb8387553a25bec45747cdb45ce6a079935a03eb13d3477f68cc1fecaaa"
  license "MIT"
  head "https://github.com/woodruffw/toml2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c236bae5e89882b86de4a4432cd45c265e52b120cfb92f5df4668a7d5d5ae28e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e916b159e93d256b232b7e05b9c70fd8efed7fcf90ba0e54f8fa1d47660fdc96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c41859623992135a393b49977c66b3defdcaf597c025ebcbb2e5ce2a1a59b220"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b63f1c3d4f53869cd7178d1150d47e24af6c4f2075e0a128a2ee180e2696d38"
    sha256 cellar: :any_skip_relocation, ventura:       "263ada74ecbaadf923978f9018950a6d361fe16d16f08033dcdea6b86bd6718c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bad30571325d81e794e04241c1536a4cfc9f645e5b32a65752e379df35c5cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ef85b1667b92098289aa2bc8a6c2747188350d052a699b780909aeeae6455db"
  end

  depends_on "rust" => :build

  conflicts_with "remarshal", because: "both install `toml2json` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    out = pipe_output(bin/"toml2json", 'wow = "amazing"')
    json = JSON.parse(out)
    assert_equal "amazing", json.fetch("wow")
  end
end
