class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/d1/92/eee81660d319463bff05233f8fa316c99e13414af276744250265c354139/tox-3.12.1.tar.gz"
  sha256 "f87fd33892a2df0950e5e034def9468988b8d008c7e9416be665fcc0dd45b14f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c07d4ba65cb634a1d91c4d0b4d4031c61a5d68810d9f37b48349e94f4f840744" => :mojave
    sha256 "c806a5c286e875cb3ab6d749b868a9482097b02a8dba32cfd9386dc341286972" => :high_sierra
    sha256 "e06628ab3f85dfbd7bc362c4d04d029e26cd32d2b233834401eca1ab31175095" => :sierra
  end

  depends_on "python"

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0e/e0/9b28879fb8e2b7062279ef50b489a9e3b49d850df068d90571a4881905ee/importlib_metadata-0.17.tar.gz"
    sha256 "a9f185022cfa69e9ca5f7eabfd5a58b689894cb78a11e3c8c89398a8ccbb8e7f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/75/21/cdabca0144cfa282c2893dc8e07957245ac8657896ef3ea26f18b6fda710/pluggy-0.12.0.tar.gz"
    sha256 "0825a152ac059776623854c1543d65a4ad408eb3d33ee114dff91e57ec6ae6fc"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/f1/5a/87ca5909f400a2de1561f1648883af74345fe96349f34f737cdfc94eba8c/py-1.8.0.tar.gz"
    sha256 "dc639b046a6e2cff5bbe40194ad65936d6ba360b52b3c3fe1d08a82dd50b5e53"
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
    url "https://files.pythonhosted.org/packages/53/c0/c7819f0bb2cf83e1b4b0d96c901b85191f598a7b534d297c2ef6dc80e2d3/virtualenv-16.6.0.tar.gz"
    sha256 "99acaf1e35c7ccf9763db9ba2accbca2f4254d61d1912c5ee364f9cc4a8942a0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/f9/c4/15a1260171956ed4f8190962b1771c7dbca4a39360c15f9c2b77e667a489/zipp-0.5.1.tar.gz"
    sha256 "ca943a7e809cc12257001ccfb99e3563da9af99d52f261725e96dfe0f9275bc3"
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
