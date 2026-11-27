class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "68ce3e0802e98d63f516a850eea987f43222988977bf597156ada414d442b093"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    manifest_sha256 "26f6cfb7b50204348de1e1041d54e1178a36e6b2a2d23c17131c55e85aa26c92"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbfe8a6aba41dc2b2e392b53afbad1f3940b372fa6bd434943119631cd9f81ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01573d28dca3ee5cc0995176252f8a2fe3e4c1a9a81a66a9026d395863fed73f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "862285f14cd98040fa1966ae1d350ba3907a0f36491da9e034b092b629388f2f"
    sha256 cellar: :any,                 arm64_linux:       "1e80648e469d25d1d09cb461fd71a1cdb225fe7058c771b7ca4d9117b9777ef7"
    sha256 cellar: :any,                 x86_64_linux:      "822c0696e2eabe9228382f4024bb17b4c64982c663974e7540a350a50fc94385"
  end

  depends_on "rust" => :build

  resource "typeshed" do
    url "https://github.com/python/typeshed/archive/bfb82380a8688a981897d923a90f5d210623081c.tar.gz"
    version "bfb82380a8688a981897d923a90f5d210623081c"
    sha256 "d2c8796875fdd6dc16f8d0afa043ca602340a99ec159878d0c455433bac20ecf"

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
