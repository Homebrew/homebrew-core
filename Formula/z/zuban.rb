class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://github.com/zubanls/zuban/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "b9982938f63f1569eb88ce0ec623a7b89e020d011b55894a7590693d0eee644c"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb80083590b2004f6fb7053104b137e01fbcd43a40869cb63128ff3204ded837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34d90f759b9dcc91ae7c7834f85b24ed781134b4d1e2fbbc088b48f8e09f22e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f48bf74f069c1b90ff3b7a9bce368c823e62133eea00b1c0e91fadda5db488dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e70cb51c38dd6279aa015cbefa71985e3cf54930c69fff5626c75090e8b2d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b26676e961acb4072a310a1e3371ee186c4ab97b315f42d0729104941f8ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2647791a08109f6295d8f62a2893a6fd66b4bcf25df029ae373058c3b019b18"
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
