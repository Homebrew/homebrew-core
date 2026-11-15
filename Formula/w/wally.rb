class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://wally.run"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  stable do
    url "https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.2.tar.gz"
    sha256 "f7da2a10865b05efe97273aa1d08e0efbb9d26fecb770d819bdc01fbb98a0ad9"

    # `cargo update openssl-sys --precise 0.9.117` and `cargo update openssl --precise 0.10.81`
    # to use versions in https://github.com/UpliftGames/wally/commit/1df8d8c9b218f7504dd9e1419383446ff18d77f8
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "d921c076c783ba1a1e2171b2975818319c7baa2429c7856c95e733f6245afdf7"
    sha256 cellar: :any, arm64_tahoe:       "8e5719321062e000855e60c1fd54595083551a459139c7a9ac857c4ba7b43a78"
    sha256 cellar: :any, arm64_sequoia:     "81ba14ad8e5f126bb65d5e16b81368bf2b9b316dff3b4a44294eda88c19fff6a"
    sha256 cellar: :any, arm64_linux:       "ffcdd332c259c1a7f08d9734d85685d52ef020cd792cfaedec2ec99edab8bd3b"
    sha256 cellar: :any, x86_64_linux:      "4b7a4da693f4deaaebaa880c961b867cc3778fc54e8a8bcaf7b4976c5a23f566"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block clones the package registry.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wally.toml").write <<~TOML
      [package]
      name = "test/test"
      version = "0.1.0"
      license = "MIT"
      realm = "server"
      registry = "https://github.com/UpliftGames/wally-index"
      [dependencies]
    TOML

    system bin/"wally", "install"
    assert_path_exists testpath/"wally.lock"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index e29ff77..3399b37 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1775,28 +1775,27 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.44"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "29d971fd5722fec23977260f6e81aa67d2f22cadbdc2aa049f1022d9a3be1566"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
- "bitflags 1.3.2",
+ "bitflags 2.3.1",
  "cfg-if 1.0.0",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
 
 [[package]]
 name = "openssl-macros"
-version = "0.1.0"
+version = "0.1.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b501e44f11665960c7e7fcf062c7d96a14ade4aa98116c004b2e37b5be7d736c"
+checksum = "a948666b637a0f465e8564c73e89d4dde00d72d4d473cc972f390fc3dcee7d9c"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 1.0.67",
+ "syn 2.0.18",
 ]
 
 [[package]]
@@ -1807,11 +1806,10 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.79"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5454462c0eced1e97f2ec09036abc8da362e66802f66fd20f86854d9d8cbcbc4"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
@@ -3414,7 +3412,7 @@ version = "1.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "1f559b464de2e2bdabcac6a210d12e9b5a5973c251e102c44c585c71d51bd78e"
 dependencies = [
- "cfg-if 1.0.0",
+ "cfg-if 0.1.10",
  "static_assertions",
 ]
 
