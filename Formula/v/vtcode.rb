class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.185.2.crate"
  sha256 "34ffdfde47186576b8dffe76d64a3c940c6575b2e0c8c939ee4533655d0c8fd7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "e3acc3308bd43ffd2fc1e9e6f841c57ad9bef9c7111eb8dff30d5042243ec4dc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c707e9e15535eb33373e1f54000f10bc2eb7bb55f15ef80548c8c9860e9cd142"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e348c129c434c2f650ae80e3458e4f35ed5862386ee74dbacc668e8e9c7ce79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "174b5afbcf217e2b3831800bfc044744feeb6daf4a319f66e4cbe4e723cbd838"
    sha256 cellar: :any,                 arm64_linux:       "ef6a912002e13f79254fe960deff7095305febea39b6df79eafb146cd375674d"
    sha256 cellar: :any,                 x86_64_linux:      "1de8716d4dcb326fde91ad78ccdeed8ef70ed02e370e12121eb81c4f405e8025"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
