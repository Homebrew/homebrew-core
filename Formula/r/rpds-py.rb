class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/98/33/23b3b3419b6a3e0f559c7c0d2ca8fc1b9448382b25245033788785921332/rpds_py-0.29.0.tar.gz"
  sha256 "fe55fe686908f50154d1dc599232016e50c243b438c3b7432f24e2895b0e5359"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24d158ab5b9de0902db1da154e3f7bd1acf3fce1da6ee0e104c0ce6703d27d81"
    sha256 cellar: :any,                 arm64_sequoia: "fbb83d5d622ebd89c66adb7e6e7bf248254abf213f194603a5ab108b8a0e45ed"
    sha256 cellar: :any,                 arm64_sonoma:  "ae93a793e1094768f9262714a7ff447efebfe706f9307765eddd5266b9695f6a"
    sha256 cellar: :any,                 sonoma:        "f8683140161ad14cfca587ab3b9583aa9bfeacc18d7ae0ae434017523fbd0712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41bece8e8e35e0b32149d00119f47cf820759fc3efbaff84b092cb03d09dbc52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbcfc6a43469bf59787a2c52bb52582d42961781939105dc862bbc9f78ca172"
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
