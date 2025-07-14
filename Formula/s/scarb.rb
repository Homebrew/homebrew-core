class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "c41fc5dbbd3fcceeecb3db87df061f11a8ba589f13076d6d37c462f8432f79a2"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97786a6c53900d30334538ade0131e6ec85d77a61d08f96699f335abe0d1cd74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb3a105e364d8d1806acd5821df6099b582f56a4eaf1c0dde98cc68c29968cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39492a366596b79683d17868b06087e50ee4a11caa426cb66882b7189fc0c005"
    sha256 cellar: :any_skip_relocation, sonoma:        "98707b1c6ee96d44662ae9fd20aea8fe3f0f47cf8cf3e6e56b562d9bcbcc451c"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc0c81feecbc49526d66c4aa8f9399164108a01d410c8a2b6fedbb436440fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ce42e23f57989f0c7aa17c7ed632656bf0143a53f899cc83175bd9b6bbe0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6db4246706b53f09624c0c3fd25396703454d1c84627180e0bf96cb86c1acd6"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
