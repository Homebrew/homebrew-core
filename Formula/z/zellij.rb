class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "fba81ade9d3fd93869338553dce394a889e6f28e0e91f98896eb77533bab599b"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb2e0cb5762e4e792ce34a043c1ff723f9a02998187b5d398e05383e05bfd40e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f6edf16fc387c5e0c27ef01346c866b028f7d6da077db4ce0d1b6280bd2c3f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a47dea17769b70c614ebc882b5247720c77b9d826c39ef4c67f45f43da4083"
    sha256 cellar: :any_skip_relocation, sonoma:        "19880908f6a9f60008d5f256dfc558f89861802b430666d8d578f11913af9ca1"
    sha256 cellar: :any,                 arm64_linux:   "e1e23a718be4c79632b05c99eb4b39bcf40e69883a04e7e2dc8924e9e7b6d744"
    sha256 cellar: :any,                 x86_64_linux:  "8a445696942e67a74f42adffc386ece62c25d3d9a50970a2ae60a2826f7efd52"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
