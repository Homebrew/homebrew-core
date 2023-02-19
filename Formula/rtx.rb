class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "232b165c290e0e2c226f8a1139ec50af6b8c5466d9bf808d1f0d48f1a0d17ea5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6208cad1f2394f5348ce34c5212a4c6959bba4c1df1633e1d919fe4bce1eaba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11cc072fc00191026dad91e041c33189bbd13373b5d21b6cfcc1489af9e8adeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcf039a547a824b09bf1f4dc4eac571dd85e2199fcd9edab20cb8ef2c069cd8a"
    sha256 cellar: :any_skip_relocation, ventura:        "2b9cb9d720b84dc38e0971f40dcb439ee3f22c0d53bc8c9737a265185e793ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "51a7aee72a17996c9a5b326958f8396784286d3f49c95b56b074ef853fe2b962"
    sha256 cellar: :any_skip_relocation, big_sur:        "cac556e6803eaadd1ca6ecbf395120ad0014d6fa61c1d08be9caacd5c781622f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a6c4e89a01bc79c19f2b06aa0769a5fa4fcfd993aa985461c4a7cd4b901ef2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
