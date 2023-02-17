class Weasyprint < Formula
  include Language::Python::Virtualenv

  desc "Convert HTML to PDF"
  homepage "https://www.courtbouillon.org/weasyprint"
  url "https://files.pythonhosted.org/packages/75/d0/d4524038147f240d029979ca0c51ab23c2f4fe06a3f5530dfbb9d2b1b95a/weasyprint-58.0.tar.gz"
  sha256 "70f482cad8e53c2c3eae9cf86af412eb93405b16ac8781b519ea3326d475bd6f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bade9b3bd90d79a2c180fdfe5660f2bae4fd4255b68622780f73c66a2492394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf60b60e6a428058124eee55e527570c20c265891504852081305a4c528c4aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b55ca0b5a56d0d0ebf12d375f2a245aa722b3f43d01ce46870ab0e4cccc4b72a"
    sha256 cellar: :any_skip_relocation, ventura:        "4edb019b0a42c8735a95b39361cf5c2572caf8801c7b0f25ce5e4598e7579dda"
    sha256 cellar: :any_skip_relocation, monterey:       "175de4e0ece84234e26ef01d773192e58bb43b83bb8f7e34d2d07cd8e8dd26c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba545fa78257f7420a07d245da7c7a0a298f9d60a320566f86d4072a4205dda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69d0528ea8b6ab4338f5e171b610e131e80f091368ddc72aa593ab86f84ddeb"
  end

  depends_on "fonttools"
  depends_on "pango"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cssselect2" do
    url "https://files.pythonhosted.org/packages/e7/fc/326cb6f988905998f09bb54a3f5d98d4462ba119363c0dfad29750d48c09/cssselect2-0.7.0.tar.gz"
    sha256 "1ccd984dab89fc68955043aca4e1b03e0cf29cad9880f6e28e3ba7a74b14aa5a"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydyf" do
    url "https://files.pythonhosted.org/packages/f4/4c/6d31b36a46714d8206b8ca84b8dc9aaf42093415b1f50471538552abe501/pydyf-0.5.0.tar.gz"
    sha256 "51e751ae1504037c1fc1f4815119137b011802cd5f6c3539db066c455b14a7e1"
  end

  resource "pyphen" do
    url "https://files.pythonhosted.org/packages/46/12/aeb28a1e1a3f3cede967cea98ef3a1da844418ab8296a4bb9513f232736c/pyphen-0.13.2.tar.gz"
    sha256 "847f57a043a58408f24670ae0184ff6edfb5fd5731743208228c028ddc514438"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
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
