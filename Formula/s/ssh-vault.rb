class SshVault < Formula
  desc "Encrypt/decrypt using SSH keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault/archive/refs/tags/1.1.0.tar.gz"
  sha256 "3bde1ad4d1f8f0eb7ade501e4b12a89e83b6508675d46286462af1eccbda646c"
  license "BSD-3-Clause"
  head "https://github.com/ssh-vault/ssh-vault.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27ff2adc2e2a950011fb85982e3475dd00f95696354090bd0d498448a65aa76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b55c4f946385ceff1df3a4f742f53a895d1582faff4b3ed155b2c8947a2d5e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd1ab07e07ca2ab36d424d8840d7926aecf18d4b223d5289adf982c219c60112"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21314b53412c0c49618b3384a885eeed3e58784e797d067f12d89dffb57241f"
    sha256 cellar: :any_skip_relocation, ventura:       "cee7b74f65d8e5d79dac9fc296a4fadfd02939790a94208c167f3aec805d0f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73c8e8b90a8ffdb58c8eb42810e8c1db67330ed559bee688f9a5fdf0c1946ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e813a71072ece7cdca7723f9fe65f7d79709de88ee0240f9fdfe8febac4929a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    test_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINixf2m2nj8TDeazbWuemUY8ZHNg7znA7hVPN8TJLr2W"
    (testpath/"public_key").write test_key
    cmd = "#{bin}/ssh-vault f -k  #{testpath}/public_key"
    assert_match "SHA256:hgIL5fEHz5zuOWY1CDlUuotdaUl4MvYG7vAgE4q4TzM", shell_output(cmd)

    if OS.linux?
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert Utils.binary_linked_to_library?(bin/"ssh-vault", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end
  end
end
