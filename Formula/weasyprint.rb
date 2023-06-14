class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/1d/69/11343bbb46d4f2a311677058e19cc2f7bc55a769b64c547a64ea1e2b6045/weasyprint-59.0.tar.gz"
  sha256 "223a76636b3744eaa4ab8a2885f50cf46cf8ebb1acb99b5276d02feccf507492"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a379987efd129d2d90b83a643332114d2c3e99047c89bda9952341a24c77d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86bfb868b1fe9da6538dc082cf129269a4de8275b75a9983601731ed6722940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b433a97422844a8ebc39d48f281831d8086a4f7e37a72c1620b7d76e92f75939"
    sha256 cellar: :any_skip_relocation, ventura:        "2b300d6980b0ad9dad544194ed56a94bcbba7b72b625ff76a6453e1abe47fdaa"
    sha256 cellar: :any_skip_relocation, monterey:       "838004b1ea224acc51e0281744faa3539ebc35e31b710df90f5a692d609acaf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "59a5d3de132056fd79c761b17bc18972587ac6d88fa5911d9d9c35f945c5e252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d971021c83213e6617f8d93b95a7d1c0eddd2fd87459afb31ac45203dd2c8e"
  end

  depends_on "cffi"
  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/9d/c5/d5e4536968c36c0838459b5c482b9228e9aae839847837623d0d04576ba0/pydyf-0.6.0.tar.gz"
    sha256 "b44a38855d7e47b740b3cd31ab63a2f5b9b2793931d50b0ccaed3bb7b86912fc"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/4b/52/46b119f94b3f68e4193ada36941606d8e26852b67bb6e099b0e310540b41/pyphen-0.14.0.tar.gz"
    sha256 "596c8b3be1c1a70411ba5f6517d9ccfe3083c758ae2b94a45f2707346d8e66fa"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/9a/ed/d004d5737f9546167eecf0ecd995ee1a796703e512deb2f2ea26cdbe4b3e/zopfli-0.2.2.zip"
    sha256 "2d49db7540d9991976af464ebc1b9ed12988c04d90691bcb51dc4a373a9e2afc"
  end

  def install
    virtualenv_install_with_resources
    # we depend on fonttools, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    fonttools = Formula["fonttools"].opt_libexec
    (libexec/site_packages/"homebrew-fonttools.pth").write fonttools/site_packages
  end

  test do
    (testpath/"example.html").write <<~EOS
      <p>This is a PDF</p>
    EOS
    system bin/"weasyprint", "example.html", "example.pdf"
    assert_predicate testpath/"example.pdf", :exist?
    File.open(testpath/"example.pdf", encoding: "iso-8859-1") do |f|
      contents = f.read
      assert_match(/^%PDF-1.7\n/, contents)
    end
  end
end
