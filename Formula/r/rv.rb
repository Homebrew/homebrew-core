class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "1548dc6411fabc6b6b91e1faca08f0f1d78b3dcbb05a0c17e42e8ec959b9c4dd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e114dd6c14e181e55d44b1f731abd2fd47aa9ea4d17e01b56a22243fcae97f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e9700d0e8de58f7bfb9fb05835b24b805b265355bb24a8aac141b538385a766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07b65ccd180830a17bdd8613cdcc346a09fe9d5842cd86e336e6f8466439986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20fc16dbf92256590d6610a37fcd396c715932a4ce04f60afdd3d5303c91d27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23134cd5fe06378a1702773f2c0c3b0d5d7173f25f6d8ad0829bfca27911d2b8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on macos: :sonoma

  # Upstream does not provide prebuilt Ruby binaries for x86_64 macOS
  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")

    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list 2>&1")

    system bin/"rv", "ruby", "install", "3.4.5"
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
