class Toml2json < Formula
  desc "Convert TOML to JSON"
  homepage "https://github.com/woodruffw/toml2json"
  url "https://github.com/woodruffw/toml2json/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "7cca2cf9339458c603729a3985211d164d07eeb1d40af4a59116aa21e25ef3ed"
  license "MIT"
  head "https://github.com/woodruffw/toml2json.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ca4a4532d8edb249db5a39b5011ef93dfb68369041cb6e2826d28f98315be89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32a4e008f4a0ad455cc5ce9f9de148d39914e2a7654dc97ffc1427ea9da17b62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659b9de6ec9dff88938220da1ba5476ec701adece0276324b0b9cd119c9d6c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e6fc12c96c7bf64544e90e786b40746905c826043b26904297d19132ec5fa46"
    sha256 cellar: :any_skip_relocation, sonoma:        "1af6af912659008f5912e892f1ec4a60038bfb4e9bacb8f3afd874a2898c04cd"
    sha256 cellar: :any_skip_relocation, ventura:       "34e24d0cb671969f44b76d96176f43618abee19fbb13375d24aa1c799c69225b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7edd47db03b8ddeef9bce364a8209b559751973ef2d69d24aa73bb508523860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3aa6df5475a72cad6908928e791de675289616259221645924914c8d380c04"
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
