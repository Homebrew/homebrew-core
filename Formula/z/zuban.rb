class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "78e8a25edf35412ac995580d91253d7f9308457ee17c02a4a8039ca3d044d130"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d52b14df80b383c4176ae3eab6688b6bbb3259f82785c6e7732da7e7e5ee9e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb4f53f2f6fdd39ac9c845484debacdf0bc4ff8e6e5f8e1fcae7e98cc8fe032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8030e8b4d0ec98c8097bda64355e9268c4eaa5323d84b74cbb3dc4a87898203"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee6d951b83ba9ee4132d2115178d7d46cc45771770f82069293397e8d57b684"
    sha256 cellar: :any,                 arm64_linux:   "8b051562316bb052b1d717349f150c503449273f703a5df7bb8960f10fb700fb"
    sha256 cellar: :any,                 x86_64_linux:  "fc5caf9cc60adb5889df153d5eaafe62c98fc3743a7c90d020e05ab1140583b4"
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
