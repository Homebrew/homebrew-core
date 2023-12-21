class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/aa/64/d749e767a8ce7bdc3d533334e03bb1106fc4e4803d16f931fada9007ee13/wxPython-4.2.1.tar.gz"
  sha256 "e48de211a6606bf072ec3fa778771d6b746c00b7f4b970eb58728ddf56d13d5c"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "62c0d6cffdb2355d9a4502e27f22d09522b54140d645bfc31506c480d758afea"
    sha256 cellar: :any, arm64_ventura:  "ecc9ba51d7c1ecccfa9e95a93e6dd9a1b3ae9389bcfd6c59ea78f64a516e21a2"
    sha256 cellar: :any, arm64_monterey: "c4ec5d486f312f880810185ff172f3cf1ad6e29d3ae134bd35dd49aa435176c3"
    sha256 cellar: :any, arm64_big_sur:  "1efd83b12803dc94280d18db9faf7c7908b923a84443b2369af4661923690d47"
    sha256 cellar: :any, sonoma:         "f5655288035b399503299af5ebb480f57bdd793f1a74a028f22be08efe96d078"
    sha256 cellar: :any, ventura:        "9ead65dce312c062a772fad1589434665706e509b6ffd7aa5f320ec9476483e5"
    sha256 cellar: :any, monterey:       "79304e35ef5f033aa46da09e3f668ce0bb1651f482c6ee853719f34f12dca430"
    sha256 cellar: :any, big_sur:        "50bbd5fb5ebf30a376cd174829ece3d81be8432fc6ae872c4e69d0fbeb0bf1a7"
    sha256               x86_64_linux:   "2b0a727845e44862bd0f74d23e0c1e2e8c91959e32d85aebff3ead82a0a10fb5"
  end

  depends_on "doxygen" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # TODO: Try to remove resources and switch back to `depends_on "sip" => :build`
  # in the next release. Current release hits issues building with sip >= 6.7.12.
  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/ce/8c/f66d1c45946e73a46f258b9628fe974ba8cc46c41b4750a59be192981695/sip-6.7.11.tar.gz"
    sha256 "f0dc3287a0b172e5664931c87847750d47e4fdcda4fe362b514af8edd655b469"
  end

  # Backport fix for doxygen 1.9.7+. Remove in the next release.
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/0b21230ee21e5e5d0212871b96a6d2fefd281038.patch?full_index=1"
    sha256 "befd2a9594a2fa41f926edf412476479f2f311b4088c4738a867c5e7ca6c0f82"
  end

  def python
    "python3.11"
  end

  def install
    # venv = virtualenv_create(buildpath/"venv", python)
    # venv.pip_install resources
    # ENV.append_path "PATH", buildpath/"venv/bin"

    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, *Language::Python.setup_install_args(prefix, python),
                   "--skip-build",
                   "--install-platlib=#{prefix/Language::Python.site_packages(python)}"
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
