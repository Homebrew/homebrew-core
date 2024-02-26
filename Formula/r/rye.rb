class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https://rye-up.com/"
  url "https://github.com/mitsuhiko/rye/archive/refs/tags/0.26.0.tar.gz"
  sha256 "40cb5813d99d604a4d32f491ff1ca65f966731d2888e6deb6f7257285ea135c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81e9233ad6351bf730913527d672d54c329bb2ebdfe83fb8012cbb37b50da162"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb96886a7b19cdfcddab64be9ab3ce4fe579ca189177b6c9d591d6cbb5a63589"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57354fcdda2b73db2ee36a261d8b90ec4215a1a1984cce0d14f6eb816b30cead"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebe758352401837ab1c04f6f43b9f672b93b1ba958af5e3ce9a2568ecd540e2d"
    sha256 cellar: :any_skip_relocation, ventura:        "daf6dcf366e896cdc4875d0a057a85b9fc1ec90eb09ac1027872e74422681f32"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd586a68cdce7f5537d133d43dd5b1bd1f4074fc68267d2da7eaf95255739e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21f4caebe9ce462bdf4375846cbeb77d090ce59fb6e695bbb17d84897840dea"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin/"rye", "self", "completion", "-s")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin/"rye", "add", "requests==2.24.0"
    system bin/"rye", "sync"
    assert_match "requests==2.24.0", (testpath/"pyproject.toml").read
    output = shell_output("#{bin}/rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
