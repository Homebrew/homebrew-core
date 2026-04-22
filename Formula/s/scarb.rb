class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "2c24f599173cc69bcf1350b49b5aa4b2f97b50355469f77e4e648b833601761d"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c73861def66d01bdd578b7ed8b634c2362e480f6ffdb0d2da23b00008d668805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7adf654ff015dec16fd76f62a3aca1274c2d36053e3f6e189e82eb69ac0d245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c275505db4ef9c8fb1ddcc2d99b4de2ea3e0fe249b3b85f0631f3c01c08e698"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b30f39df715de4e675befd48b506c7ae4f1610e148f2eb242ff31067cc5bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05489e481bdfe73a4b31fa73cf0bed87421b343d5a8c5b7dfe499a7d30688793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc59824731f38034ed0a02e44b6a5758cd57d86a8344e3b0ae45e59df3f9b94"
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
