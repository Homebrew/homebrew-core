class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "743893d2a7a2ba657ff93e0b8ec92437ce210d6dca2f21cc3ccb2b20352c9426"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74a2aaec98834192abf07e94875427675044b68125a083fdde74005d3f116082"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e8f8f95ffced2cd2052c8065c69abcc39c737de073566b03f17041db6e535dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "066b65aac6fe46f8495176c74088b8439920488887582284e76e0e81ff7b2ba6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c16ceb0142b20384b2fb6599e8747404fa0a8c35b3b57b1896583bbf11997b2e"
    sha256 cellar: :any_skip_relocation, ventura:        "9e66fe15a4fe2fcc092dce5d91a8b4a8c1a7d5e97d86e51ba4053115cc3d2b63"
    sha256 cellar: :any_skip_relocation, monterey:       "3414d0dd3e5f0dd9e5cb14b7de119860681e1f583b5ed2b8a4690d647cab44cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f19bef1177484c57b81a268f55b32606906eeca3c688e54e871138f1dfcffb2"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
