class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "faae6cac22e9034c4db9e53e0c95b3736ece70fc4a00bb3e6c4890cf9006696c"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "3fba5e738487e8236602d1526119fd8dc2d0803aaff9d7f10515a487cf1496db"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "000ad7b26069bcd7de7a833a8c79aa74d7954acfa71ad912831816df0e4ce2cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c3c1f245681c2ae75571fb0ffa4cb8018151b74c03c36c415c0b2ac62a9e7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcc3d05b8e7ba0c609ef3ef9df6723ecac1252954503535f5946e079389a7614"
    sha256 cellar: :any,                 arm64_linux:       "fef2d002f212a94a0cc8d6e6aa9aa913f60be7389e4afbb5b9aaab88e50ac038"
    sha256 cellar: :any,                 x86_64_linux:      "55f68f6450e63cf544c5558c305cb02563b2d4d00db12e69a86671339377a11c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `scarb-build-metadata` crate uses `cargo_metadata`, which requires network access
  allow_network_access! :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |path|
      system "cargo", "install", *std_cargo_args(path:)
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
