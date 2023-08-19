class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/36/9c/00be291ff608ca73cbc9662c1c59cddef20279298e0fb410ca1ec1875c99/snakefmt-0.8.4.tar.gz"
  sha256 "277eb436d4d61161d2c75c6eece44df34bcbb6299bc3f4fffafb0976e16afe40"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78fa80a9a0dd8bed819be21b14eb7f5ba5256e26a3ba79da185ed73dbbc162b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3df170687d2d0d028e335724a8d8c0ba1294671fdace69565b54ad0ec901573"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6e7660112c57b1db419e5374a4402c2d6b39cc69f7a1bdbd0a3557f459539b3"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f0e554d2aa849e04e1b8c5dd003468f5a80865339e1965c2678c52b3449678"
    sha256 cellar: :any_skip_relocation, monterey:       "e70923304c46034abb3af0cf3993ca7b24673a0e38edf9142862d11425b0e6de"
    sha256 cellar: :any_skip_relocation, big_sur:        "9057a5052ecc45abc5df3ba28b0daaaf5a8ba017a99887bda5f676af7597e0c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890638778841809d83b6fc803cd9ea611c0b1aa2d80cb3f8c35f49373a61eef7"
  end

  depends_on "black"
  depends_on "python-toml"
  depends_on "python@3.11"

  # Switch build-system to poetry-core to avoid rust dependency on Linux.
  # https://github.com/snakemake/snakefmt/pull/199
  patch do
    url "https://github.com/snakemake/snakefmt/commit/cee8a662c286fc78a593534f5700e08a7096c822.patch?full_index=1"
    sha256 "094e56dd75bf2506ac3c73ab9877cd2a56137092c98bd8063404f57a77825536"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    black = Formula["black"].opt_libexec
    (libexec/site_packages/"homebrew-black.pth").write black/site_packages
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
