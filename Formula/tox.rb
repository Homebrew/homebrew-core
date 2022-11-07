class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/86/71/604b19466b3310a02fdc2baf4b559d8f49bf932a7e6f976a238e2bb54516/tox-3.27.0.tar.gz"
  sha256 "d2c945f02a03d4501374a3d5430877380deb69b218b1df9b7f1d2f2a10befaf9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93dfa6012c8fc19d89885e1fc8935d6601f6f0ab27841312a1fe3a6356e90453"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ab7c2f831fdc85e9d8fa997129513a2e6de049dd52b54c6f2ab14f804d4da0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0b231f8d810690031b15d3953673fdf9456336391e3b9cdd3aff359ad5b6a7"
    sha256 cellar: :any_skip_relocation, monterey:       "30f44ec2fbd45fd1bbf712a65353391e16a26742dede171bb23310ea3513c4de"
    sha256 cellar: :any_skip_relocation, big_sur:        "88e5c44ac5fd1b57a8b4ceef4408fd778a1729259cd43b51f0a1864a348f5ca8"
    sha256 cellar: :any_skip_relocation, catalina:       "8953a3c7ba870b6036fe8575cf95e45e99c3dbcd865084ec99adabf3b35e7ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b513289410d10d5a867acb27bc9d52004bbc8d3b48d452669eba5ad49562d916"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/32/3d/711a708e9b69b263e5cf190a030a77fd79a05613820f6ce0c7ea6f92f99f/platformdirs-2.5.3.tar.gz"
    sha256 "6e52c21afff35cb659c6e52d8b4d61b9bd544557180440538f255d9382c8cbe0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b4/27/b71df0a723d879baa0af1ad897b2498ad78f284ae668b4420092e44c05fa/virtualenv-20.16.6.tar.gz"
    sha256 "530b850b523c6449406dfba859d6345e48ef19b8439606c5d74d7d3c9e14d76e"
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
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")
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
    system bin/"tox"
    assert_predicate testpath/".tox/py#{pyver}", :exist?
  end
end
