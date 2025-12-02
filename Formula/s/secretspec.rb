class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "eb22f9f4c47abfe64559e482cd3a60d3e6616343f6b7c4a9ca47fd97c0e9e392"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5c0a4c4eed522724efacbb835c1688fc1100e6932769d670c35e07d8c6b4876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd486a8036482f1cdfa87739567930f6855954ab1004b5685021c2f4346c5566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1623bec3d5549fb267041e32ade479a0647f31114605fe2aa3748cc09218dd7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "653e5e8051d083decef0066a31a9c8910ae4b5ea9170b6b81d51f3b13f99204a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35809a4cecc2447880911c27f4755ff498ae197b777098d6366093f38048a659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c227fe68b658e35eacef23ca013511befaf87799fc167abd2c7841a0f8be62a"
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
