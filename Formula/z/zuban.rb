class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ef18bed5412da00667862751e16b4cf66039ae39e3618ef891f58d089fabe5c0"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44f56bd96874e552a8901e65c7aa6e393abbb7c0c07a91dd2e01405db26bb39a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bedded60441bcd5c80d7a6f8569a1815921edf25ac19bc8be00a66d0f4962b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76def94832f0ca408ebcfe7d48b156342557bac5d119222c3c61b28344498e0f"
    sha256 cellar: :any,                 arm64_linux:       "c0eab74c1361f4fa021100605ea625e6466c264e2ca1869ffad47af4edfefcb1"
    sha256 cellar: :any,                 x86_64_linux:      "e75b29203145732eaa07a5bf90c574b1d4199662a328b6f5138240d95251dfb2"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
