class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/d7/42/82308785b76b374456218b4f1f9f69075d081cb5b4f287766d21a30565dc/tox-3.7.0.tar.gz"
  sha256 "25ef928babe88c71e3ed3af0c464d1160b01fca2dd1870a5bb26c2dea61a17fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "86a638b3df47d21d5d92a78bf16a7467fd6dd3e485f94117fd6ace5cdcb7601f" => :mojave
    sha256 "0816bb04a0dc557c895329de749d2584f3f6ed9ead0db6b34387e8d6f9f439f0" => :high_sierra
    sha256 "904fd9ef383137f357e9c1b2bf1f12ec90766e232e47fa17a6c4d9acb424228e" => :sierra
  end

  depends_on "python"

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/2a/bd/6a87635dba4906ae56377b22f64805b2f00d8cafb26e411caaf3559a5475/filelock-3.0.10.tar.gz"
    sha256 "d610c1bb404daf85976d7a82eb2ada120f04671007266b708606565dd03b5be6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/cf/50/1f10d2626df0aa97ce6b62cf6ebe14f605f4e101234f7748b8da4138a8ed/packaging-18.0.tar.gz"
    sha256 "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/38/e1/83b10c17688af7b2998fa5342fec58ecbd2a5a7499f31e606ae6640b71ac/pluggy-0.8.1.tar.gz"
    sha256 "8ddc32f03971bfdf900a81961a48ccf2fb677cf7715108f85295c67405798616"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7/py-1.7.0.tar.gz"
    sha256 "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d0/09/3e6a5eeb6e04467b737d55f8bba15247ac0876f98fae659e58cd744430c6/pyparsing-2.3.0.tar.gz"
    sha256 "f353aab21fd474459d97b709e527b5571314ee5f067441dc9f88e33eecd96592"
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
    url "https://files.pythonhosted.org/packages/59/38/55dd25a965990bd93f77eb765b189e72cf581ce1c2de651cb7b1dea74ed1/virtualenv-16.2.0.tar.gz"
    sha256 "fa736831a7b18bd2bfeef746beb622a92509e9733d645952da136b0639cd40cd"
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
