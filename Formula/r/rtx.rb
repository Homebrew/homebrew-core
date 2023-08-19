class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.2.tar.gz"
  sha256 "beb69e87506d411a7ff75880a16911a5830fc9a5af6896da81568a7164f6cd7e"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bedd519871437f7e8c051be99990cda17fdf18608e4deec1c015dfbf81858bdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6864b30e7158f93dfccdf93ed12dff9af81c2ac4ae890b2ed68885eb7e0bd01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a430c2937e4cf83cbd3cd01100dca02ebd61934e7e8412c82c1cfcb796462b3e"
    sha256 cellar: :any_skip_relocation, ventura:        "d7bca9d1b2e6b3edd0533f8c7e1f1e852a5876618c10f097e3068cf9981a321d"
    sha256 cellar: :any_skip_relocation, monterey:       "d45f8da96bfbe73195b2820f8bcf8a6e6b8922cc1e8215284a949190e614d9c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac0cd3ed4831ad37efba3c047ea680d0771e4125c6429bc7b06dd3cf4b28faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0106b8066f4ef2b55b88c1fcd71c21ba92a17cab2038008cffea1cf44e17259"
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
