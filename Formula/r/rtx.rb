class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.9.1.tar.gz"
  sha256 "6ca8d847db6cf74b428fc5f092536dade0fcc9af6008e2c657a1b4c77624e9a2"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6676b4240787af6103e009bae3d7b99b1c991864647ed7efe1e51da3bbcb9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61f424b8fa307905ed4eddf537a4ff8f79ae9e906cf579620c2dc7c2cad7f0da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "194ddfd3d0d70b38e9657d89861f8042c1e0ad56a1fd5529d4ca9db0a1c2a14d"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe8c8fef2d9f40434b40f0eadf46ca51dadba9821c1040febb4c0daaa087672"
    sha256 cellar: :any_skip_relocation, monterey:       "12135c3aefd0d68d11569e7589857e442f716c8dc1016ff9464fbebc2190898b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d453b7689e293dd6b0d486df40d4e739553004ed4b7ab48927b3b2461b6c6427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ce959fc97529828fef35fbd8936c3fd7c131bc15e86abc7362718d8af7c567"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
