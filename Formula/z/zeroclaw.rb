class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "04dffd8881698ba4a5fa8ffcfc49fa026a520cb5c1ae1c75469411f4e897c4b4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1637ccc47141f3aa97d66b37aacaa232ddd03bcddb47abad2edffae634dc0b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "228f9f0b3ec4f3ba4bf48a08572b258088c84776d60b36bca900a8aa2ad09cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995aae3401c04ab77a2fc2345e62826a7c624cb0df32a945c411fbfe6e8266bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd008e35ad27ddbba3a59ee0cab8fa092a764132c76db129b1669c01e96c2bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46987134cbeb3e9ed96bb7fb65c3c8989a65e9faccb601408c885b8e12595fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43b98dfc121402a2d9e1e6bbb2a7ec474a6601ee05ad8a5642a15ff2b58691b"
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
