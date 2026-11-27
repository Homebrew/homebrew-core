class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "68ce3e0802e98d63f516a850eea987f43222988977bf597156ada414d442b093"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    manifest_sha256 "6d1767c9c5b4ee1b3eed569967fbd49a3fd5624ea8c871a7bf60a58be8b26ab8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0432afe8748b41dc42c111601f1b607fe108969099ee86d3638dfe2d052321e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bceea8b5542ac376580104a669c50c23c1c4be86525eceaecec7c53418c5ef2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80717248002ff8465b18f6b3f6e6181b938ffac5c5e6406c56bfedb3762dbb7e"
    sha256 cellar: :any,                 arm64_linux:       "e4035341466a4996352b96525a10b43b5367e78a1a8b853456b3119c4d0481c6"
    sha256 cellar: :any,                 x86_64_linux:      "c4e6c9f89138e853f84c260ce442359098a41b58dfd1154b53942860c2fe2df4"
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
