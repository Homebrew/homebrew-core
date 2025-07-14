class ScryerProlog < Formula
  desc "Modern ISO Prolog implementation written mostly in Rust"
  homepage "https://www.scryer.pl"
  license "BSD-3-Clause"
  head "https://github.com/mthom/scryer-prolog.git", branch: "master"

  stable do
    url "https://github.com/mthom/scryer-prolog/archive/refs/tags/v0.9.4.tar.gz"
    sha256 "ccf533c5c34ee7efbf9c702dbffea21ba1c837144c3592a9e97c515abd4d6904"

    # patch libffi to build against rust 1.87
    # upstream pr ref, https://github.com/mthom/scryer-prolog/pull/2895 and https://github.com/mthom/scryer-prolog/pull/2956
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9e835b97c19a21a9e951a9cb4f3e63b2df085d146a45e1a83fcd6f7c2e2e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a56ddd4c07ac2d2b7efaa3d425e8372164d177ae2051716004fe690c4581788"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0384d324b743441527508b58a077149303dd2dd96a5503c369408f9719cc5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e024f19ee8e58837198cd389c3b7c480ba7c5e387d0857f4922661a79e7c18"
    sha256 cellar: :any_skip_relocation, ventura:       "ca1a6421cda477896165eb0565e298dee3d6a8cbda834b96319d8ecfae1d3b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3568e4dbd9505bd8bb67952b815e18631d464d1608295e9d699b91669533fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440649067671da13802d98cdcd24d605c6eec246d55b3be4b8cb90c612ee7854"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
        write('Hello from Scryer Prolog').
    EOS

    assert_equal "Hello from Scryer Prolog", shell_output("#{bin}/scryer-prolog -g 'test,halt' #{testpath}/test.pl")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 5e406c6..26f3d5a 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1477,9 +1477,9 @@ checksum = "302d7ab3130588088d277783b1e2d2e10c9e9e4a16dd9050e6ec93fb3e7048f4"

 [[package]]
 name = "libffi"
-version = "3.2.0"
+version = "4.1.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ce826c243048e3d5cec441799724de52e2d42f820468431fc3fceee2341871e2"
+checksum = "ebfd30a67b482a08116e753d0656cb626548cf4242543e5cc005be7639d99838"
 dependencies = [
  "libc",
  "libffi-sys",
@@ -1487,9 +1487,9 @@ dependencies = [

 [[package]]
 name = "libffi-sys"
-version = "2.3.0"
+version = "3.3.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f36115160c57e8529781b4183c2bb51fdc1f6d6d1ed345591d84be7703befb3c"
+checksum = "f003aa318c9f0ee69eb0ada7c78f5c9d2fedd2ceb274173b5c7ff475eee584a3"
 dependencies = [
  "cc",
 ]
diff --git a/Cargo.toml b/Cargo.toml
index 2af52e2..af8a464 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -80,7 +80,7 @@ serde = "1.0.159"
 crossterm = { version = "0.20.0", optional = true }
 ctrlc = { version = "3.2.2", optional = true }
 hostname = { version = "0.3.1", optional = true }
-libffi = { version = "3.2.0", optional = true }
+libffi = { version = "4.0.0", optional = true }
 native-tls = { version = "0.2.4", optional = true }
 reqwest = { version = "0.11.18", optional = true }
 rustyline = { version = "12.0.0", optional = true }
diff --git a/src/ffi.rs b/src/ffi.rs
index a8ffd74..835a06e 100644
--- a/src/ffi.rs
+++ b/src/ffi.rs
@@ -53,13 +53,23 @@ pub struct ForeignFunctionTable {
     structs: HashMap<String, StructImpl>,
 }

-#[derive(Debug, Clone)]
+#[derive(Clone)]
 struct StructImpl {
     ffi_type: ffi_type,
     fields: Vec<*mut ffi_type>,
     atom_fields: Vec<Atom>,
 }

+impl std::fmt::Debug for StructImpl {
+    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
+        f.debug_struct("StructImpl")
+            .field("ffi_type", &&"<???>")
+            .field("fields", &self.fields)
+            .field("atom_fields", &self.atom_fields)
+            .finish()
+    }
+}
+
 struct PointerArgs {
     pointers: Vec<*mut c_void>,
     _memory: Vec<Box<dyn Any>>,
