class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "9e6c2abb4a7599bd1d8169dab6e2da19f1916afc8ff99374ee6f5a5f5e801176"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c697e804eeb65ae74496ac245e0a0ed9a2f94bd96ab0f58d93af0cdcc8dfa6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "047142ce75e2e9e288e8e1cc7dde56e130d2e48b43cb9e371a1cf34fb982dff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fc98660220ccfa4ce7a0d3b385e7db82c5c0ebedeff66c1f4f623d57bc2f66b"
    sha256 cellar: :any,                 arm64_linux:       "ad2275a6d4083b79ada4293e215ed34a24a704dc82098cf0abbb1091da14896b"
    sha256 cellar: :any,                 x86_64_linux:      "de60cbdf1f18fc5c27d52f2a8f62a6bbbaee0627b507454350786fc51419bd64"
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
