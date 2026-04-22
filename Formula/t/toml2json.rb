class Toml2json < Formula
  desc "Convert TOML to JSON"
  homepage "https://github.com/woodruffw/toml2json"
  url "https://github.com/woodruffw/toml2json/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "70c9bf872f22d22691d41eeb06442a0fddf4b341ddebfadf8734d1e68e0174ce"
  license "MIT"
  head "https://github.com/woodruffw/toml2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b2b0427521ab532a532e7c79660a039ab61e4d25d40b110accec10b997e4d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d3a1fdf26a222e53b14398cabf8f8d726359ab6bd73969ac6a814f3d66564f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba3deb56cc6c7fc853bb0f3917017886f687b73df694911bd31d07d1d281517"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ccb30451c3fee454908111290d7b20c7213ec146e1c7152e5e975a40f78b96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b4499857996bd712c846e7850c8ad38ffc013b633ab9e160c191bcd0f1383e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "786b289aec4e5444f47921cdece21b0688c8915c99fd985b70b72e2cbe123323"
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
