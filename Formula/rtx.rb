class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "3ba8a14a9dd9494682f83bfbad9280cd9f43569e5890669a1bceab4287798055"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b6e602d25ea8f83427a1168b22dfe4eb9fc383bc17a1ded78aa585905603f11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "014e78257b80f591ad46ff9ab3c8cec0a7424de948cb276f2f69b1cce1942817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bdd7662e2086f443ce62030eff48643da9c274d48614a8229246088b8c3ea23"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdbb7ee117e7d07ce085f877a041982cb9f33a7d68a40cf6697fc4aa99b382a"
    sha256 cellar: :any_skip_relocation, monterey:       "18134970bc877c692afd362dd920df8ff4fbea34bb1334cf92b379c20436aed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c963d8c343a06030c37b4f15e606957903d7dee303f99e4518cf6970f11b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f0b397b0032f85f398226679eabd948b982160339f652d1129d26c983c30d5e"
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
