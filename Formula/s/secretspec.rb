class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c1fa70acb99da0d591844cc9631886b2b5c18ec67c9460f46d358dd6a13f16b6"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1141545cc6b5bbf14cfe8a128a3e3003c7fff93d929c9a259411332ad4ac667f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed9ce8fb0ec844c90d3e94603a8735c8e1792cf1bb7037405fc74bdf91d421a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "307aadbb01b5efa518e059d2030f99851933037d6df9f8ee07b76ee3a9c89dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "55e2202bba1ff56f7ad07e4eade4005dc72d079052f48f95f1942d5c9b9a5e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de96283cc4ea35519da7fcd7e6c274e2cdf80a244e6655a7866735b65257f30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84798918f333dbd7b874592c49a515f5f893e3ca8680cca801368316814a4eda"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
