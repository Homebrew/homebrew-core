class Rustpython < Formula
  desc "Python Interpreter written in Rust"
  homepage "https://rustpython.github.io"
  license "MIT"
  head "https://github.com/RustPython/RustPython.git", branch: "main"

  stable do
    url "https://github.com/RustPython/RustPython/archive/refs/tags/0.6.0.tar.gz"
    sha256 "bf290cf7a70f813758819d895868b2b49b9edea1f10de3524df2cae1f2d58a4d"

    # Backport the SQLite converter fix. The upstream test hunk needs newer tests.
    # https://github.com/RustPython/RustPython/pull/9443
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "027b8d2ac35fc6044ce6a29208a751c28d4886f7f3ba8b1688175b27caaa246d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c023db1f504419fcf1b784d729f8d223fcd4a3aaf569d563b10d5712887cd6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efc8dd046f37dbef10db87660808e3893792292e04d4f95088f65b53aa10aef8"
    sha256 cellar: :any,                 arm64_linux:       "41643e1fddef82f23163068ebe0b5d1adea0161be04838266bc053d90c5b0689"
    sha256 cellar: :any,                 x86_64_linux:      "dbd53494f3e85d61dfd47b0ef14e6ec31858d8ce1e2025a57d36917fe58e6109"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sqlite"

  uses_from_macos "libffi"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(features: %w[freeze-stdlib sqlite])
  end

  test do
    system bin/"rustpython", "-c", "print('Hello, RustPython!')"
    system bin/"rustpython", "-c", "import sys"
    system bin/"rustpython", "-m", "venv", "--without-pip", testpath/".venv"
    system bin/"rustpython", "-c", <<~PYTHON
      import sqlite3
      conn = sqlite3.connect(":memory:", detect_types=sqlite3.PARSE_DECLTYPES)
      assert conn.execute("SELECT 1").fetchone() == (1,)
    PYTHON
  end
end

__END__
diff --git a/crates/stdlib/src/_sqlite3.rs b/crates/stdlib/src/_sqlite3.rs
index 0fc0454af..ca2b22c72 100644
--- a/crates/stdlib/src/_sqlite3.rs
+++ b/crates/stdlib/src/_sqlite3.rs
@@ -2529,22 +2529,31 @@ mod _sqlite3 {
                 if detect_types & PARSE_COLNAMES != 0 {
                     let col_name = st.column_name(i);
                     let col_name = ptr_to_str(col_name, vm)?;
-                    let col_name = col_name
-                        .chars()
-                        .skip_while(|&x| x != '[')
-                        .skip(1)
-                        .take_while(|&x| x != ']')
-                        .flat_map(|x| x.to_uppercase())
-                        .collect::<Box<str>>();
-                    if let Some(converter) = converters().get_item_opt(&*col_name, vm)? {
+                    let mut start = None;
+                    let type_name = col_name.char_indices().find_map(|(index, ch)| match ch {
+                        '[' => {
+                            start = Some(index + 1);
+                            None
+                        }
+                        ']' => start.map(|start| &col_name[start..index]),
+                        _ => None,
+                    });
+                    if let Some(type_name) = type_name
+                        && let Some(converter) =
+                            converters().get_item_opt(&type_name.to_uppercase(), vm)?
+                    {
                         cast_map.push(Some(converter));
                         continue;
                     }
                 }
                 if detect_types & PARSE_DECLTYPES != 0 {
                     let decltype = st.column_decltype(i);
-                    let decltype = ptr_to_str(decltype, vm)?;
-                    if let Some(decltype) = decltype.split_terminator(&[' ', '(']).next() {
+                    // Expressions and columns without a declared type return NULL.
+                    if !decltype.is_null()
+                        && let Some(decltype) = ptr_to_str(decltype, vm)?
+                            .split_terminator(&[' ', '('])
+                            .next()
+                    {
                         let decltype = decltype.to_uppercase();
                         if let Some(converter) = converters().get_item_opt(&decltype, vm)? {
                             cast_map.push(Some(converter));
