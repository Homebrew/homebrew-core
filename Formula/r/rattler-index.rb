class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.3.tar.gz"
  sha256 "76b4b5bac10d2c638c14354ecb9b7c99e581f6878524e5998298570e6963228e"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37e522becfbed1f4495e85a06cf29dc6134923459d744e3f7ff22ce1f4cef8c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b17729d8e80b532ff4fae91478643fad53199075faa23909ed9661f919b87bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6a24ff89b6ec93769cfd55f5a8de5934af23b9e1d354cf93de521767f7133f9"
    sha256 cellar: :any,                 arm64_linux:       "2932316fa21685cc81da037955ed7e44c4c4bc3a61a4209482269f056fe8b938"
    sha256 cellar: :any,                 x86_64_linux:      "a6eeaf87cfb2e59caaf0744fa3191a8272ee1c8ee424d5420750d428e3506c60"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
