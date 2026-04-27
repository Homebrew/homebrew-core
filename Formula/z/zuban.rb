class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.7.1",
    revision: "6549dff425c4a10b71a9a465625faadccee0c789"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff617b26f136de342f0d97e580f896caeff102897cd20df8281dc8b01303279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1317a16cc17f27729aee781834d6f9e7901fb3bcd3a7d6b9cdc38925b31cfc00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294e5189a2b55259c3b38786cadbf5bb869440673e11b4481e5b8e8333963edf"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a3ccbdea4217e3d5d79f83d8c30ffa59e51111a339cdaad459f35c87c2fd5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97ab2eb5745fc0c6881f8469f56d4bf5aa6a2ad6482f591fd9ea8614d4859f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66dccecd8f6aff821f13e0a73e71e0466e7156d50a57feb855a6906d6eeb46e3"
  end

  depends_on "rust" => :build

  def install
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
