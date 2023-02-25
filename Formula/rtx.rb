class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "c50dc7407bd66cea8b0671284ba8f0909e66dc963d84650226804fb31e46dcfe"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74f975d2173b52ec552cac200f6bc03d7190b95681c203751e8b646cd7a9dd73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00c582a8f9205f3dfc147085baba29a64ea8253e71a4b795c12de1ee2365217d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed3f63c43b16617441250698b5db6aa93b0246c8d0ffb0cc22b5e1954946734"
    sha256 cellar: :any_skip_relocation, ventura:        "a24ba6c374544b2b6bd896c979b4f933723166ad3f393b0bc1ec5e871d78cdea"
    sha256 cellar: :any_skip_relocation, monterey:       "0f6a3556e9e0672fa2ce75c9854e1092c976ce89f38a1701eb733e3462b72cef"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8cfd9781e154e2013a50afa7e8e8ba14d03ca75a882d3899d2a9ddc3696a64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f1e793a6a3a76d63760bf5aa8967a649198a004af5a354058d5afdbddd9d4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
