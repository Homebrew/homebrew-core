class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/42/68/3bd46b8a5e01d3c2ebdf9c5e9497912e3fe0cde02bac21a7130ca866e403/rpds_py-2026.9.1.tar.gz"
  sha256 "4793ef7f78268b124b73fa933440f01d258bbae01de9fa53e9080c9ab0425a12"
  license "MIT"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a154a5dfe03e74b4c9e234b03857192b03d6481ed8778cdb10153520cdf71eb0"
    sha256 cellar: :any, arm64_tahoe:       "cda0d16b742cbd255f000cec01112f8355b1dcd38d5b8258559867c0e69e4922"
    sha256 cellar: :any, arm64_sequoia:     "7d5a8f7549ab54ef273b015bdb5c954f06854f2b15f42eba37a715023ed3d63d"
    sha256 cellar: :any, arm64_linux:       "81a8d22e6e5b2ae6e6d1a3be6c2ff199ea67b54f00b8ad273ae8e1f920c529c6"
    sha256 cellar: :any, x86_64_linux:      "1110f82cf16b2b59f14a609975a8ed0d96bbdf15db592427aab441437b6e979d"
  end

  depends_on "maturin" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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
    (testpath/"test.py").write <<~PYTHON
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
    PYTHON

    pythons.each do |python3|
      system python3, "test.py"
    end
  end
end
