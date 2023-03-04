class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.21.3.tar.gz"
  sha256 "4620e3e63707cbae48be6d4d8b1d97ca8b1a06e7f7e2f28d1f1fa4f32cbfc5e9"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f03268c7b7f24dd55bf8aa1ee850b372b88a362498c23aeb7dd2ed3622a530b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b2edc9d7309602284708520962ee785ad30035f715b4b37bbfc5ebc661336e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "175133adf29cb9ebcb99acbd0e16d7f9840523f9bc4ffbee19d84573a0b42c57"
    sha256 cellar: :any_skip_relocation, ventura:        "db382a2eac04e60a33fccb25cce55990f044786dc9a4320d19a84ba4d90f74ad"
    sha256 cellar: :any_skip_relocation, monterey:       "4891a0331cc4bb533d4e35e27924a6b9b93a067781db70831c05b5712a8c8cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "03f780211c633a3b7b2bd64fff202ce41a7b0740b074d94bdac429a59ef34fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93157b404b372b7673a434abc7a620fa4f86e267e3b13ecee0d7bf93c90dc86e"
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
