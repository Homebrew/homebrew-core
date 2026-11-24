class Vedic < Formula
  desc "Simple Sanskrit programming language"
  homepage "https://vedic-lang.github.io/"
  url "https://github.com/vedic-lang/vedic/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "4086cda18ed78fd6b42455062834ec7aefea1aceefed650370f2469e989e56e4"
  license "MIT"
  head "https://github.com/vedic-lang/vedic.git", branch: "main"

  bottle do
    manifest_sha256 "f60ed99ed9afb3a345180790c4805873c4fb6a585df7ae709fc2c3a95596f016"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f427876bfb8aa9949f3825e90f9cdcb4f7932e8790dfdc204c8d4fbd8114e43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92b55b7bcd037492749cfd01a0e370f11c65fa836f5160800feb8492fc2c5cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a558892d0dc0b400eba6f8ad4b128585201516794c23b11caa1a975929082254"
    sha256 cellar: :any,                 arm64_linux:       "121db67b9ae5bdfa5bf6fc1dcd05ec793c11edbb0afee339a6281731f5171e1c"
    sha256 cellar: :any,                 x86_64_linux:      "853fb28f1be0c21e71a7371f319cb96a54c773e1114c0a7e1f47eb43e822c080"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # hello world in vedic
    (testpath/"hello.ved").write <<~EOS
      वद("नमस्ते विश्व!");
    EOS
    assert_match "नमस्ते विश्व!", shell_output("#{bin}/vedic hello.ved")

    assert_match version.to_s, shell_output("#{bin}/vedic --version")
  end
end
