class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "551d068ebd18439f0c8d4f69f65f3154d51178fbbc0340f17ec5ca330333ebb7"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a8b10d5cd45fa8d606d86f29688e6dce38aa04cef31d6e1214ad2d71c99d649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e69aeba750f19f35e90b071ec84e77addd3ea9e54db88b97a7457e7c15cd2353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be138db043c1117b05b69b87db4f0de9d8e5300391fbda36032e6cb39a830827"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8a53b90cccad98a69e719042b15d73d2afd771cb1fe6019c4fa9c1a06df8e5"
    sha256 cellar: :any,                 arm64_linux:   "3148a6d1d64fc6b011e6d06e30a3f8cff69532c4db378e61fb91407526589432"
    sha256 cellar: :any,                 x86_64_linux:  "5b8fc5af2a10665bd1d78a71e41ac079b37774204ea5dd97a925f60a118d32e7"
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
