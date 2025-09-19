class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
  sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dfdc2a23b9a10d279609cea5f703e604254089dd772ac9fcb30d8aa867421ce"
    sha256 cellar: :any,                 arm64_sequoia: "e17b3cc293b9cc2f526646db82c1d20d85b884322d84fff93c7ff04051850c28"
    sha256 cellar: :any,                 arm64_sonoma:  "8c4d924d33a30ba311f0a2e8282941e1ddbddfd0bf4c9b8436456fc79bb57bf2"
    sha256 cellar: :any,                 arm64_ventura: "f6adad66444b44c0bf15113ac82b0bb913830eea5c893fa6acaaa54f88be210e"
    sha256 cellar: :any,                 sonoma:        "1b1465aee8f9bd25b0ea26e3bcb65838be0a9ddd8e8caaf282d51e145eb020b9"
    sha256 cellar: :any,                 ventura:       "cc80eb9a387b580b463ef6165f0db1ef5a588be76cd2543131586017a3f29fd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "502856e5264fdd8d959218176c90c86554b530aba64b13dfa6bae655480111c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ca5c4b5b6254fadcfab7d21d00871079c7b3cf2fbd1aac200a6ca076fe9caa"
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
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/e0/92/bf8589b1a2b6107cf9ec8daa9954c0b7620643fe1f37d31d75e572d995f5/setuptools_rust-1.11.1.tar.gz"
    sha256 "7dabc4392252ced314b8050d63276e05fdc5d32398fc7d3cce1f6a6ac35b76c0"
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
