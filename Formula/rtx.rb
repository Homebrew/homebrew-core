class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "31c5b5689c779705b2dea74795a3ce655a7c0edc1e7c16410eb3cddde05a9a93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8f7483e316a5bc20c3c7e1372be5d93db9f59f6f85c3cce6ed9aceddb04f64e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc0864ba6039a815167aa591e30a1adea05f631935c482ad660a797dd68d8610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fa853d4ce3c393cd310d327923f3754328418dd0f66c0b4b90d4749238d1a81"
    sha256 cellar: :any_skip_relocation, ventura:        "0557975809dba892ba941c1027365a1caccc107d00a4fd22fd8957f45ee75c55"
    sha256 cellar: :any_skip_relocation, monterey:       "927400f401c124100d9d7c810c9e884c613686f17a2a4f097f295c6ffacd6f01"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6494dfa64c8d7ba3d04e8fd45eca902deefd200a9a0003dd59e318c8a747845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c64b5ebfada68b01c7c67c021d4410296b30d37d0fcc8b0bdf86bb50da9732d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
