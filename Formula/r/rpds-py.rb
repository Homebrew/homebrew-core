class RpdsPy < Formula
  include Language::Python::Virtualenv

  desc "Python bindings to Rust's persistent data structures"
  homepage "https://rpds.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
  sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "861d730b8272341a70880c589bd68bc6dbae3a281bc4733b9c61c0a26e3d1445"
    sha256 cellar: :any,                 arm64_sonoma:  "236798bd2bb430633396f72d81861a4195ae9bbb61f8caaa1cc719e1b7ea58b8"
    sha256 cellar: :any,                 arm64_ventura: "f11e2eddb045ea64ed825be18ccf3dd5ea1ea722271526be719ba850375db349"
    sha256 cellar: :any,                 sonoma:        "101cfa99276d97abcf8c9271cc5288c68753f08f0845c355eb62862fbf0bf48f"
    sha256 cellar: :any,                 ventura:       "c47efc703935b0802434b0cb7195a2e831fd484c90411cfb8fd4c0b302407dcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97dc7e126e9fe57ae7c7b4fc0710c0b6e0aa2f7e42bc1aefec132dec2e1bed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac767aa702f065dc74258d02f39ae3b47ea7a30ab1ae5b94c4b99ed15750128e"
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
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
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
