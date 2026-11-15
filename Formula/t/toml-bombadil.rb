class TomlBombadil < Formula
  desc "Dotfile manager with templating"
  homepage "https://github.com/oknozor/toml-bombadil"
  url "https://github.com/oknozor/toml-bombadil/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b911678642a1229908dfeabbdd7f799354346c0e37f3ac999277655e01b6f229"
  license "MIT"
  head "https://github.com/oknozor/toml-bombadil.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "bf34e466f3b5087d06b02a43b7cf13584c1ea2376e1ecf8dae4ef57b7c987e62"
    sha256 cellar: :any, arm64_tahoe:       "03489419a8f4267bafc143414f5653c534f59d197379f817cf836120782b665f"
    sha256 cellar: :any, arm64_sequoia:     "fde0bbe597b847280f1c825edda6c47aa889ce7fd83a093cb2a6793693f7079a"
    sha256 cellar: :any, arm64_linux:       "c0ba6177aa7c0714130906191f7ef9f6a5069ce5f5bea48ead7d5f2e98434728"
    sha256 cellar: :any, x86_64_linux:      "b81e05150ecc567f86d57179c177b89f6bfa0fe9d051ec34110766d6d90cd567"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/oknozor/toml-bombadil/issues/480
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bombadil", "generate-completions")
  end

  test do
    config_dir = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    (config_dir/"bombadil.toml").write <<~TOML
      dotfiles_dir = "dotfiles"
    TOML

    (testpath/"dotfiles").mkpath

    output = shell_output("#{bin}/bombadil get vars")

    assert_match(/"arch":\s*".+"/, output)
    assert_match(/"os":\s*".+"/, output)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 43f1552..b6eee41 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1817,9 +1817,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
