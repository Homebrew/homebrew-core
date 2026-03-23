class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "fb02bb880a22494a63b61e7e0669fcce1e61250db0b0bd60942114a1c0dcb640"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27fafc6ee6cde5b801e2425cfe828c6de3bc1857d26bb66ca9ef56ef90f04c46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f21799d830a4dfa8a29f1096eb3f16eed3d9748df7ad72b7735c360f38c236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0493f22d510bb97965ebd83fb878c2b81a6767d22b3f6f51051d8baf81909f85"
    sha256 cellar: :any_skip_relocation, sonoma:        "a094a372bac1c9bf646e0e48b7dc16080cd53ab37d197d38f5af9702687f2ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "debf2d0042a3bf7c72367ebb48472cd409f9149b533d970a457a039939ed9cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c21e3170a86b655897eeef69292bff4050f44c1b1678a7924c84f5f46fe06a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end

    generate_completions_from_executable(bin/"scarb", "completions", shell_parameter_format: :clap)
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
