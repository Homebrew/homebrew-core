class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "8d621c57b10bc6ff81dcfaeb09930563a110f6c96d9056afb04643a68cef7357"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b54fc05f151da2aeb25b97e36c07b8b8268b48ff7b45fa314fb8666087e335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886b626ae0f97b784dcf31e5566a85802d4e92afd7973d5d93c76ac848257620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a965c7ac5433881808cf78dd703a452d28f88c59728030b459d60a5a877576c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "665373eb3e32d46d1c9be9fd32c38521e49b830029709e1f211de8f274878a74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b527ef874b11144f0260edd8241d3520b73ececbdeaf03d3867ffea073383518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1f7db114da498edfd70442dafa292dfa1aa8dc65be7d1db92f4e176426bb0f7"
  end

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    # Work around zubanls not reading ZUBAN_TYPESHED (https://github.com/zubanls/zuban/issues/53)
    (typeshed = libexec/"lib/python3/site-packages/zuban/typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed").first.children, typeshed
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: typeshed
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
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
