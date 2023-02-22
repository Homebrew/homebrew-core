class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "31c5b5689c779705b2dea74795a3ce655a7c0edc1e7c16410eb3cddde05a9a93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35e9c465c3d5f68d0a76e44bd41aea2d8af743d143cb3e9637a1df5097341d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1a5ee3631b199bc003cc793ff724f32b13f82b34e97653265d08a4909b8424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef4cd892097adcef3e0df5a0fb108cbac9d7d8bf611cc4a760cf213a45a4be0"
    sha256 cellar: :any_skip_relocation, ventura:        "932281423b64d3eada462e6d399a486b26d93ed4bf4d7c6547966e626e4ef434"
    sha256 cellar: :any_skip_relocation, monterey:       "f68b34ed5c5d4e8f0c10551a6dede1a9161ce332e8aee323ae4efa8f8ca67e1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc334e188c6a9942a59d6591c77116c647b3f1263ab4db9b2a2415298a14d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cc5af84cff8a8d7c7124e9ad2e30af9f3d3d962fde3a660cc7a56c1872c0f0"
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
