class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/0.12.11.tar.gz"
  sha256 "242e80ee70311f05871353b2d8f4b2c9a568bc0789321c4c6dd2c51e8c13633f"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f86981b5062ba4f2382c6be48232248624e0b4a38902d900e5071e6246728731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e86b2a90a05442c7e883447d5139fed351bf0c24a1110def35d3cf3130c028"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2d0a3f4a23913ff935e8ee16278f6434eb105e2b0a10597ad535e63c71e090b"
    sha256 cellar: :any_skip_relocation, ventura:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, monterey:       "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "626b79f4e43c94b0032b7c96971205441e54988955e8cbc741ec380d45ce17f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e41cb587b634237268bf413e3e8b57925c1a55002598a343f9c7bdd41d7354"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/ssh-vault create -u new", "hi")
    assert_match "Copy and paste this command to share the vault with others", output
    assert_match "echo \"SSH-VAULT;", output

    expected = if OS.mac?
      "Error: No vault provided"
    else
      "Error: Not a valid SSH-VAULT file"
    end
    output = shell_output("#{bin}/ssh-vault view -k https://ssh-keys.online/key/xxx 2>&1", 1)
    assert_match expected, output
  end
end
