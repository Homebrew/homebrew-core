class Typstfmt < Formula
  desc "Formatter for typst"
  homepage "https://github.com/astrale-sharp/typstfmt"
  url "https://github.com/astrale-sharp/typstfmt/archive/refs/tags/0.2.9.tar.gz"
  sha256 "fa24ee1705ff5fec4db45e301d38439d0bd3d6d4ee04b280ba997b2f94ba16d9"
  license one_of: ["MIT", "Apache-2.0"]
  head "https://github.com/astrale-sharp/typstfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90a1443ca38d6ed8b1a6cc21102622ad5b830d82948ec590d0435b010c147b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2385acb81ddf04da547278e4beb2bcd6c8b75d6798e29cded3d1ed7300d2940"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b960ec044c1a222f614e9fbfce9b5b844e7f5a040d1c93c583b0b74ebe2c4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "13b69d0ba9cf2046a896e2a2aa49aafbe640ca594d05ff2ab221288eb7c76e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "52c9b488a0f712675ba7a36b68f383e991fda985d6bed8e2062de3e46369f8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b2b049e67eb424c44c33ae4e2321d7ed018eb5c8b373640224df3ba8e1719a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2282db238b16329daff514c79902b36c8d0c0035f1bc45a0749641568889de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstfmt", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstfmt --version")
  end
end
