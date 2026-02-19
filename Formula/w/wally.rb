class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://github.com/UpliftGames/wally"
  url "https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f7da2a10865b05efe97273aa1d08e0efbb9d26fecb770d819bdc01fbb98a0ad9"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8c9d6350d3eefbe0f7ffdd8ae0e3848ecf54079dfffb4bb0dc820d41c802c2af"
    sha256 cellar: :any,                 arm64_sequoia: "ac406b7fa1ecb8ea08e890b2f58f021bc966e7cc1073e8a57a4dbddfab32223b"
    sha256 cellar: :any,                 arm64_sonoma:  "f231366bd7b5e801852f98c63835485b66da481b7b867d527790575ac401aced"
    sha256 cellar: :any,                 sonoma:        "985950f162544863811b7bb0757f8dc945036d81d5c3ac4eb8592e10ea04d62f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ec8105b54551fc7277e01e3cbe506921aa0ec643c16722e58adf5fcf546668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6280085aae3f14cacdac8fd689cd77781132ce85b22afa0acae875c0e82811a3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
