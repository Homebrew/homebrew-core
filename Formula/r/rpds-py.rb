class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
  sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "263f26952c943f8704b81c9d02de7f744f0482537c9b99cf38af8159dd3f880d"
    sha256 cellar: :any, arm64_sequoia: "659f5e783e028cf5ea05b913597226d7de497c63117440f8957faae3e57fe10f"
    sha256 cellar: :any, arm64_sonoma:  "65f0b0a05280247f885ac4fd00526870f00d25a483f3b254acd63ffd2aa2722d"
    sha256 cellar: :any, sonoma:        "3fe3248e249a5fc2bbebbc6cb25b2a5d70a8b9095bfadb27ab84de9c60167ae6"
    sha256 cellar: :any, arm64_linux:   "58af52827af49ff40a20fa7db4dbd254fb2f9d58c6729e30c0d79340d614e88e"
    sha256 cellar: :any, x86_64_linux:  "4a2d9a2c14fbe07e34f533e18133f1faee06edd1a648c61d261c77ae3d743ed2"
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
