class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0a/79/2ce611b18c4fd83d9e3aecb5cba93e1917c050f556db39842889fa69b79f/rpds_py-0.23.1.tar.gz"
  sha256 "7f3240dcfa14d198dba24b8b9cb3b108c06b68d45b7babd9eefc1038fdf7e707"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f0654c6182c426c12bbd57e0f7a55b662475737fbe32ee94de5b87631e5e278"
    sha256 cellar: :any,                 arm64_sonoma:  "a92eeec7bf2da5e2c6b1dfaf53b293a24748d9af54b38f07dbd442e28d56b0c1"
    sha256 cellar: :any,                 arm64_ventura: "d2d6de90d070bba87aafed5468b9ad06f9160710a1b80ad4cc0a74e003351fcc"
    sha256 cellar: :any,                 sonoma:        "189b36e2d6d884b1d53a92aff6961cd888be19c40aad2eb11f2c935c997a35e3"
    sha256 cellar: :any,                 ventura:       "7d08d1705551d2a9a38a1822511f2b6cb0f7028714410f46d83de66daa12ba83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d865aeb961599cdcbf006e9c28154dc170883fee176b88b7d712d8f71a7313"
  end

  depends_on "maturin" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "rust" => :build

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d1/53/43d99d7687e8cdef5ab5f9ec5eaf2c0423c2b35133a2b7e7bc276fc32b21/setuptools-75.8.2.tar.gz"
    sha256 "4880473a969e5f23f2a2be3646b2dfd84af9028716d398e46192f84bc36900d2"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/d3/6b/99a1588d826ceb108694ba00f78bc6afda10ed5d72d550ae8f256af1f7b4/setuptools_rust-1.10.2.tar.gz"
    sha256 "5d73e7eee5f87a6417285b617c97088a7c20d1a70fcea60e3bdc94ff567c29dc"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    ENV.append_path "PATH", buildpath/"bin"
    pythons.each do |python3|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)

      deps = %w[setuptools setuptools-rust semantic-version]
      deps.each do |r|
        resource(r).stage do
          system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

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
