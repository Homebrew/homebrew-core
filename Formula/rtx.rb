class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "3a0d098e0725057036575eb62e77010cc74c2ec7d283b72f605b7f20da143523"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "273e7cb430e7c19788c0ffbc1db6941189aa2178a5d23ce4331eaf40cc82fdb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95378b71cdf862709c79e848a6098b5054035829f076cb72f841a22338580a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dd554df8000ea726c8733563ec0b5854defb5a71d046c2dc2e502e1263460af"
    sha256 cellar: :any_skip_relocation, ventura:        "fb7ef002103d0db889ae00d958f79bdb9dea865951f9d7de87542aa3d05b814d"
    sha256 cellar: :any_skip_relocation, monterey:       "a8a66219d7d7f0045c59087b6636aaa716f507f0bcd36aab217081b777559419"
    sha256 cellar: :any_skip_relocation, big_sur:        "77964e1a9445c5a255244017f5018d750c86714027ddb20228c54289ea1e3359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "572fa6f2323ffa3e88d8f85a50993cb34dec954719e2e1df832684b92058d8b7"
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
