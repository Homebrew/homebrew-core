class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.47.0.tar.gz"
  sha256 "805f5b47dbb17c70627c50af3809b02c89cdfb425424ab4d9f766c09dabfb3a1"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502f65f9bbb119170b38925a53b6e6b42f6cfc32a7536be6cd5e05a05f9d9ef9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14afb22ab9728634a5fe52eecf65db6746b22f843cf86e7063398a0f070f465"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26744a9ff01e85aaaa3d190a9bee396cf1eda1d0518986d1de36aeb5a7dde446"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c53a9ded296d05965fbf749498de44684d77c858a13dec83a7065f863c780f3"
    sha256 cellar: :any_skip_relocation, ventura:       "076269f6a248e8c8853d669780ef4c8abf722d7ac4c45f888157e91aa63fe2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92712ba7993149b712e9287ec6725bae545de2b271952856b34c6e41d1794289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a79e9d44827b7cbead3315382013245b3f891f9de19171b010559fa4746483"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
  end

  # Allow setting environment variable to disable swift sandbox.
  # Upstreamed at https://github.com/getsentry/sentry-cli/pull/2587.
  patch :DATA

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end

__END__
diff --git i/apple-catalog-parsing/build.rs w/apple-catalog-parsing/build.rs
index a381d4c8..2a1027be 100644
--- i/apple-catalog-parsing/build.rs
+++ w/apple-catalog-parsing/build.rs
@@ -22,19 +22,30 @@ fn main() {
 
     let out_dir = env::var("OUT_DIR").expect("OUT_DIR is set for build scripts");
 
+    let scratch_path = format!("{out_dir}/swift-scratch");
+    let triple = format!("{arch}-apple-macosx10.12");
+    let mut args = vec![
+        "build",
+        "-c",
+        "release",
+        "--package-path",
+        "native/swift/AssetCatalogParser",
+        "--scratch-path",
+        &scratch_path,
+        "--triple",
+        &triple,
+    ];
+
+    // Allow swift to be run with `--disable-sandbox` in case cargo has been invoked inside a
+    // sandbox already. Nested sandboxes are not allowed on Darwin.
+    println!("cargo:rerun-if-env-changed=SWIFT_DISABLE_SANDBOX");
+    if std::env::var_os("SWIFT_DISABLE_SANDBOX").map_or(false, |s| s != "0") {
+        args.push("--disable-sandbox");
+    }
+
     // Compile Swift code
     let status = Command::new("swift")
-        .args([
-            "build",
-            "-c",
-            "release",
-            "--package-path",
-            "native/swift/AssetCatalogParser",
-            "--scratch-path",
-            &format!("{out_dir}/swift-scratch"),
-            "--triple",
-            &format!("{arch}-apple-macosx10.12"),
-        ])
+        .args(&args)
         .status()
         .expect("Failed to compile SPM");
 
