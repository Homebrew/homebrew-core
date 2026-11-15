class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "294e896edd2e0452577065cb784545f29ce68c41431c6d01f6416acc2ad02c9d"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17f000326b181af9ce97c41818cb6440cbda0e20ad9732a079a38d1c31aa540d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5e5ef716901ae7129bddffc8956c712a1828e290337f82b9923f91a88f689e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06b4cca83e2b6d6e45baf3a761a8c3310d726b1ac77b9a570aa7e68d43b1004f"
    sha256 cellar: :any,                 arm64_linux:       "eff71da655e8595f8674c2c3b98453474ea01302ea7312e82dd12eaa5267bb2c"
    sha256 cellar: :any,                 x86_64_linux:      "ae7c70ec52f1ce3d80a10e23b32e0bbb4320b0ac4725f8f02a3891c66e2ff4ad"
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
