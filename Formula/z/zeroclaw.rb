class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "5ee0bf2e341a4c5fd9f47ba242fe3e23fc1ac82efa22a6d483d9da7f5391706e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a975ecb422c2d489e7d48c26c811343764e8efb63f981cc6a55b6a71ca60e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5d661e683012b8eead478640f7177cc9ad81a9657a626f2e273a80a9472353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f97731e47a503993d3f3b6d9c916b41ab8a05ca3dfa714b291580d48e9dfdef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "003a1182453d803f266cc2fa6e7ee6f1e692fce81ef46a7eab34f55d51f69854"
    sha256 cellar: :any,                 arm64_linux:   "426fd7df567d902f24a9eaf913490f586499bd668ecae8b5bf502cb166477f0c"
    sha256 cellar: :any,                 x86_64_linux:  "18f1173fa206f407de42eaaedba0623e49ab7563ec39154bc506f121a2c05f7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
