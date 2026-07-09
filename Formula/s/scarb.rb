class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "d43829b85341ef15f44dde79281f0d1c0ad54e18a6f835862117447f68a3aa43"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6427691f62ca0c2baad82b43b84dbc2945cc367c6ce405ecb4c677e7eb162353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2501b40c10a92ac0c91b38faca91efa14e5b91da98cb71e06b8745e9838e230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e5386d94d8fe50db9e662071bf6f3d786e772f4c229be60c49e852cecd33b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d69ae08bbb18914dcadc000a8dce04522b995960f13df484c0a2192e8dca11"
    sha256 cellar: :any,                 arm64_linux:   "0c5ca28a2d0262130cdaec0e0bc07bf6232ab980b346469069d6e2585edd3a18"
    sha256 cellar: :any,                 x86_64_linux:  "f17f9736d2cc4aeaf37a525e0e735e9de17c6f5ffa453cae003d50311d8539a8"
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
