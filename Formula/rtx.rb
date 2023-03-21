class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.25.6.tar.gz"
  sha256 "10f59bf1dab5e8177f82ad174261da7c0f68e50aaba110b498ead58df06a9c3d"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f408568d09afcfa64bfffee84d83a1067512644d1eeee0ed053d0e43d2e29166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083ed51e352b9c291d96795f7e50a3a8342b3de9cdd9c04fba4316b5b54d6304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b311b09b4ab68aae565d931c8136ca0705713eb7c083be76f2c8ff8e87d724e5"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f7baeba24e32dfdcd985e29b9760c6c2dd6cc85faa6954fd45001ba0f033df"
    sha256 cellar: :any_skip_relocation, monterey:       "21fb7e1653628593b14b123f6cea0388e12c07b9576b5f91f6188c513abc19a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a40e71220d5dd746c9a3bec4e12371bf5bdef2180bcfc42054b9d9419d31eff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af767b43b7545aee4442762d5c5662d0c4e289a116e646e8a5944a853f9e26ac"
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
