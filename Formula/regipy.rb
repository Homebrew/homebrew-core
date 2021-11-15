class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/a6/b6/3802f55a1bf3deac4f5d0affb27126413f42a5d5cdda656c053300a8f42d/regipy-2.2.2.tar.gz"
  sha256 "1c4efd310f72b199efaa7ceadc579045fbe7e96cb334775cd3f01a1700dda9fa"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c396e4a403bccfe7579ef4d6063546891ddc422cf96e88e5db98cd5d853e239"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65bde2359f6cea2012de6377582fe86b620c893419e59a3d0ba2a0af573d5653"
    sha256 cellar: :any_skip_relocation, monterey:       "329e74155de78cbf02dde3f27b51decea0e237b5e3293533f898df6150a5d496"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8c0464d42e06441ef795e42c4f51f0cd0085fd4cde9b918729ac3cf9e52157a"
    sha256 cellar: :any_skip_relocation, catalina:       "0e5704a454d7eca2f3258b2848eba9465118f42422fc2e406a8f49cae67765d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b63444a2649158903112ae1115e3e582e159cc5abd02487a37a6fb35b6251ea"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/39/2b/c68eaf8294f01ea534f39b8b4ec1d7308b5195e08570c276b104bccd24ff/construct-2.10.67.tar.gz"
    sha256 "730235fedf4f2fee5cfadda1d14b83ef1bf23790fb1cc579073e10f70a050883"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "test_hive" do
    url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
    sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
  end

  def install
    venv = virtualenv_create(libexec, "python3.9")
    res = resources.map(&:name).to_set
    res -= %w[test_hive]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    resource("test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end
