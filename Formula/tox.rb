class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/9d/fa/e3428607370756d134fe4c222658bad329cac419a01a6a88c84d8f1adaa6/tox-3.13.2.tar.gz"
  sha256 "ee35ffce74933a6c6ac10c9a0182e41763140a5a5070e21b114feca56eaccdcd"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c9189386bb9c8003c3f8d77e438eeb69266edaaa17477f4f7aa50f9cc25239f" => :mojave
    sha256 "44846281dab267074cdefbd33ed8f2bf30b216e2a162b7bbfd7bfc4813b3d8d9" => :high_sierra
    sha256 "d4a609edc507339f7a3952d536ea54c1606f083acd6f815ad3fc7440053f5fd9" => :sierra
  end

  depends_on "python"

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/fd/5c/9caf9fe3d92afc3c0296c97b0fd72cacfcaf20e8b2c42306840914e052fa/importlib_metadata-0.18.tar.gz"
    sha256 "cb6ee23b46173539939964df59d3d72c3e0c1b5d54b84f1d8a7e912fe43612db"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/16/51/d72654dbbaa4a4ffbf7cb0ecd7d12222979e0a660bf3f42acc47550bf098/packaging-19.0.tar.gz"
    sha256 "0c98a5d0be38ed775798ece1b9727178c4469d9c3b4ada66e8e6b7849f8732af"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/75/21/cdabca0144cfa282c2893dc8e07957245ac8657896ef3ea26f18b6fda710/pluggy-0.12.0.tar.gz"
    sha256 "0825a152ac059776623854c1543d65a4ad408eb3d33ee114dff91e57ec6ae6fc"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/f1/5a/87ca5909f400a2de1561f1648883af74345fe96349f34f737cdfc94eba8c/py-1.8.0.tar.gz"
    sha256 "dc639b046a6e2cff5bbe40194ad65936d6ba360b52b3c3fe1d08a82dd50b5e53"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/91/53/f4dedc34f7a5797c35e451d67740560a384168f79c32e127b22a91f96ceb/pyparsing-2.4.1.tar.gz"
    sha256 "530d8bf8cc93a34019d08142593cf4d78a05c890da8cf87ffa3120af53772238"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094/toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/97/f4/64c1853c3b35c1cfa57f3485b49c8c684f9dcaba4e24c56717b83fc66e90/virtualenv-16.6.2.tar.gz"
    sha256 "861bbce3a418110346c70f5c7a696fdcf23a261424e1d28aa4f9362fc2ccbc19"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/66/ae/1d6693cde3b3e3c14e95cf3408f24d0e869ead42a79993b611d8817d929a/zipp-0.5.2.tar.gz"
    sha256 "4970c3758f4e89a7857a973b1e2a5d75bcdc47794442f2e2dd4fe8e0466e809a"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
    inreplace lib_python_path/"orig-prefix.txt",
              Formula["python"].opt_prefix, Formula["python"].prefix.realpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    pyver = Language::Python.major_minor_version("python3").to_s.delete(".")
    (testpath/"tox.ini").write <<~EOS
      [tox]
      envlist=py#{pyver}
      skipsdist=True

      [testenv]
      deps=pytest
      commands=pytest
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/tox --help")
    system "#{bin}/tox"
    assert_predicate testpath/".tox/py#{pyver}", :exist?
  end
end
