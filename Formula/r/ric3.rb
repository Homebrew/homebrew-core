class Ric3 < Formula
  desc "Hardware model checker"
  homepage "https://github.com/gipsyh/rIC3"
  url "https://static.crates.io/crates/rIC3/rIC3-1.4.0.crate"
  sha256 "cac95faf25c88a114df82d38d34a7c3748e11ae14b3e0e22a57b35c0aeb26060"
  license "GPL-3.0-only" # v1.4.0 predates upstream's BSD-3-Clause relicensing

  depends_on "cmake" => :build # Native ABC and CaDiCaL bindings
  depends_on "pkgconf" => :build # System libgit2 discovery by libgit2-sys
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use Homebrew's rustc with upstream's unstable features, including ptr_metadata.
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    # Skip ABC preprocessing, whose subprocess IPC is blocked by the macOS test sandbox.
    ENV["RIC3_TMP_DIR"] = testpath

    # A latch starting at zero and retaining its value cannot become bad.
    (testpath/"safe.aag").write <<~EOS
      aag 1 0 1 1 0
      2 2 0
      2
    EOS
    assert_equal "result: safe", shell_output("#{bin}/rIC3 --no-abc -e ic3 safe.aag", 20).strip

    # Toggling the latch reaches the bad state after one transition.
    (testpath/"unsafe.aag").write <<~EOS
      aag 1 0 1 1 0
      2 3 0
      2
    EOS
    assert_equal "result: unsafe", shell_output("#{bin}/rIC3 --no-abc -e ic3 unsafe.aag", 10).strip
    assert_equal "result: unsafe", shell_output("#{bin}/rIC3 --no-abc -e bmc --bmc-kissat unsafe.aag", 10).strip
  end
end
