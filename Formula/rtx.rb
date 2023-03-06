class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "df75447e8face2aae14bf3c06311b68c2f0ab1d1c6a313fd40fc174c0cb4fb7f"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f987bc23eb89e6ec01f7a625f69dfa53fc0ffb0b87ffddf8d287b563d5322360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dc5e0a3efac7d95e213c0a51726bda7191849440269e48afd9130150896ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa6531c492b38ebe7c7e6c23727497a34a3f12b6bc881eb5881b0bf38696c3fc"
    sha256 cellar: :any_skip_relocation, ventura:        "5851fbe1bdc5099869767ac48e8a9e6a14a7f6186758114cde13f81f629f30ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d5374824c1c8b348cd52f2b2fd67e6551bcec54f356fc75af9807265a1b5cd62"
    sha256 cellar: :any_skip_relocation, big_sur:        "839309f5e151f6f53d9a44fd56e778bfd872c060995f1d1de5c323219d7621a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87cbe02f8f8629be488756e1520391bcd1f6156abb134bb87778239cc3b77758"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
