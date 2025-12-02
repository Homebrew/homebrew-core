class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "bd1bc61367420dcbb1ab46df53a46fd7d35379960c9ab39bbccb7ace5afaeb62"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a29f7f69f33b0dac172ab89994c6d3538bc5730644fbac53d423e3dbf43b682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298b762aae2f3d85767ff186854b274d75b684276c91bb9048a17142cb690e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8518d30560a1d752ced697787cd009e895e13e72c2d07f59413321f487abea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6bd7363df65a5b02121c0ba2ad2267983432e70a1a4396dbd5dab19a8c4c673"
    sha256 cellar: :any_skip_relocation, sonoma:        "392053a600ae8d3a24db90f17c2e1ff88a4a00d047c15ec94c112cd193b9d70b"
    sha256 cellar: :any_skip_relocation, ventura:       "22194f25fab54b3543e2902d2b028d9767a00788bbc69eb4bc9591ee7682aaee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259fa1d80abdad023497161eddfaf32f334a32a867302506884c0ae149c2a859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da1bdb071e5a0e473a01d3cfbbbd88546184c20c61b0fd14b9b941b449474f3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m▀\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
