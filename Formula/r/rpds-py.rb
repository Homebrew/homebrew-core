class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/20/af/3f2f423103f1113b36230496629986e0ef7e199d2aa8392452b484b38ced/rpds_py-0.30.0.tar.gz"
  sha256 "dd8ff7cf90014af0c0f787eea34794ebf6415242ee1d6fa91eaba725cc441e84"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "715388516c58816ba10a5458011fb92a77970c58544d4167c6e36de71b193f6e"
    sha256 cellar: :any,                 arm64_sequoia: "bd16aebf97d58de866e2041ee66bcca16c9f55a652100f9514cc0d313b8803fd"
    sha256 cellar: :any,                 arm64_sonoma:  "6e1ce5a078da634180ffd96bebf737afab0967954852a16c90f733f2eb858138"
    sha256 cellar: :any,                 sonoma:        "3808dbe98500333e04280e14b13b13eaf99d72273ed0080dcc2d2f69debe7044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f51f49db0cdc7e4096374c349e02cca662493409941321c9a5975cfcc3c25ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2de518db42c0db26a5d5bc60bca0af22ed32d44043bf6bb42755213523a659"
  end

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      assert m.insert("spam", 37) == HashTrieMap({"foo": "bar", "baz": "quux", "spam": 37})
      assert m.remove("foo") == HashTrieMap({"baz": "quux"})

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      assert s.insert("spam") == HashTrieSet({"foo", "bar", "baz", "quux", "spam"})
      assert s.remove("foo") == HashTrieSet({"bar", "baz", "quux"})

      L = List([1, 3, 5])
      assert L.push_front(-1) == List([-1, 1, 3, 5])
      assert L.rest == List([3, 5])
    EOS

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
