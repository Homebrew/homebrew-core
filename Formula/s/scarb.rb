class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "68474e59dc0567efce97893a5d584798e312e935830038220977a23e15b13663"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29736fae0f339ac1e39eff55b05919bb98a5cea22153d3a1c2e80e3907bcf002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bf4ff5b40397af79437945e663503dac86761848fb7d5d1c0752fe7b72be733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ad5f724738f4ba6521d8d528f40afab8c74a7c90d230c017ab0159aaa01636"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37d19c746e04d3f973cc569606718521f30bf74e98ec247852365556c76d85d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33c1f373c7fc37add49955a98832850fd426f30669d87d262c640d35e519c564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5b8e532334192624e4a0f8f98d7e9269dc30b2e20e010fd4af5d50b086ed6e"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "none"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
