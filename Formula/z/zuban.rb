class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "02c73169050cc309bc5df9587481a8222888312f2e5aec46c94cb8f78e4bbca2"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7841ba0176a94538b4d4a9c608a7c349595e0e8f1b1e43bc6f47e5d32df5d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd47c2307b91001b1490c5337fc99c09c2e156e49b53414765f6594eef37458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce722f31f67c97def519c1cc4d0ceaa748127093085da2d97db9f5dbc44a440"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa737a8e95c058441655ea3bf313f4eeecd0f433fe323f3f5e40b488d6f5b6e5"
    sha256 cellar: :any,                 arm64_linux:   "5da51daefcd309778eba0dbbb44f11420cfa4d5981c8ddcae5d4365a1bca9c1c"
    sha256 cellar: :any,                 x86_64_linux:  "2ab592e58f34bc26cc80fb2b25407be28da61c1cfa8d78f2980c5459763d6529"
  end

  depends_on "rust" => :build

  resource "typeshed" do
    url "https://github.com/python/typeshed/archive/aaefc85a95431045b0726b297d0ad1f4786ba1e2.tar.gz"
    version "aaefc85a95431045b0726b297d0ad1f4786ba1e2"
    sha256 "46980e94b26f9653d50ac6d1fc3d5a5f58fc90bb3f1b6517d9ca51ec381a71ae"

    livecheck do
      url "https://api.github.com/repos/zubanls/zuban/contents/third_party/typeshed?ref=v#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
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
