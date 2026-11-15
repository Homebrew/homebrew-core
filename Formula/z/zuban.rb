class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "70b9ee27d93d1615cbfa24e7e40d44698066e2e0723383554a9403bda3e4165b"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db3fa4be19f6028eb338b3167943fcdd89573825f7e49fd5ddee6dcd97e06527"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cddce86c5fa5c7a73ea7c3df7cc947fcfed0bd9047619a3a88e5eeeef680575c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45bad6ed56c494d41ad16f526d766e887077804690658fdd97d84dc89577c156"
    sha256 cellar: :any,                 arm64_linux:       "7212f35ab6bfff6c18ff15179286e83db2983ee9f2d03346d18c9706bd3736b9"
    sha256 cellar: :any,                 x86_64_linux:      "4e8c4f60a1a0aef96ac89e894c810df888e8533931658e9c5e3f84f5e2896438"
  end

  depends_on "rust" => :build

  resource "typeshed" do
    url "https://github.com/python/typeshed/archive/e75a39fec6f375f5002d54c5607b44bedc025a4b.tar.gz"
    version "e75a39fec6f375f5002d54c5607b44bedc025a4b"
    sha256 "05c0f2faeaa57766ace6f334e9aa667e5abc16a6f611f0c9b1b42c92d8676f7f"

    livecheck do
      url "https://api.github.com/repos/zubanls/zuban/contents/third_party/typeshed?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/"third_party/typeshed").install resource("typeshed")

    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end
