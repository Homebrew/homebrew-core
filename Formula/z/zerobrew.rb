class Zerobrew < Formula
  desc "Fast package manager alternative to Homebrew, written in Rust"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dbbddff4b22a264e993ab7b254e0eb87a958a559c8438671f4eac3fd5517868b"
  license all_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "zb_cli")

    generate_completions_from_executable(bin/"zb", "completion")
  end

  test do
    output = shell_output("#{bin}/zb completion bash")
    assert_match "zb", output

    assert_match version.to_s, shell_output("#{bin}/zb --version")
  end
end
