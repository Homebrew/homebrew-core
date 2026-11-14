class Tubeup < Formula
  include Language::Python::Virtualenv

  desc "Use yt-dlp to download video/metadata and upload to the Internet Archive"
  homepage "https://github.com/bibanon/tubeup"
  url "https://files.pythonhosted.org/packages/7e/44/6deb75f6d3a553fe3f8dfbd7c0fdea15f31b67272808efad98303803cca7/tubeup-2026.5.8.tar.gz"
  sha256 "4c75423a429493bddaf78ede0031947938b3eb35435847ee6597b49a4be76ad7"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7dfd819f4da560d642739a5765cce82afd5c637ebe4c9e07ab7a7789426ca84d"
    sha256 cellar: :any, arm64_tahoe:       "f9f9e19e2e703eb739a554fb8eee01829c23fdfb20f7accc5dca875700350e26"
    sha256 cellar: :any, arm64_sequoia:     "f6e7352e045199021a42e204d101c551477831db84d783f3bd13a19ddfe9cbaf"
    sha256 cellar: :any, arm64_linux:       "c1e5f8c823e035f3cc4457be22aae5efeaf7afe79bc8a1f3673cabe1d89e9023"
    sha256 cellar: :any, x86_64_linux:      "01bdb98f1c601d2c38e3850c36af718ae1e2b7c4b250d5784d5c8c3a37d101e7"
  end

  depends_on "node" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi"
  depends_on "curl-impersonate"
  depends_on "pycparser"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cffi pycparser]

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/96/4c/69074f9797d83a5401b3c6bc58c5de5aad6d1a085d0497b87a093a152e87/curl_cffi-0.17.0.tar.gz"
    sha256 "31ee8500d06d6502ce1ec0b7ded1c5aa8e8f3401bbe37ccd78d6153d859d8f3c"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "internetarchive" do
    url "https://files.pythonhosted.org/packages/a5/e5/6299a3f04c085c9d3582840e2a086a3845e89b2ae5058fb817fca0a99795/internetarchive-5.12.1.tar.gz"
    sha256 "fa9589c463a8a64e1c194f19f40bac680e2db9b493a0d9722cf7d30754cde65b"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8f/13/43ae689f9340dc7339dc7f5a3b1772edcd48fb1eb62fd5d801a2aa09d382/jsonpatch-1.47.tar.gz"
    sha256 "5ed650b7517789e0f43428aa7b09442c0b90de0a0fd17a53fd0ebf55205c601e"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/46/cb/2c3112a061a718d93866c2555dad1e9d53865e4703d0f3be550d252b277b/jsonpointer-3.12.tar.gz"
    sha256 "7a3dcc11b64053eaa9c549e85e413f8d40a075215f793a331bed9182a14251ae"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f3/c2/f5855412372e47d635599a97c00cfcf9fc40accac9436a11bf9ded19f859/pycryptodomex-3.24.2.tar.gz"
    sha256 "e4dbc29e2575365d15e272f769329106277649aea081e2119cf43d66950f8f8f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/83/31/4be3987022a6244550ab6a3afe45ad10ac10b5e5ab8874bd8eecc7f8b937/yt_dlp-2026.10.26.tar.gz"
    sha256 "abe5c6b94c3b2f0560500add1c42e0a97641752743a5b65588ac2007a6e23eb6"
  end

  resource "yt-dlp-ejs" do
    url "https://files.pythonhosted.org/packages/d3/e6/cceb9530e8f4e5940f6f7822d90e9d94f1b85343329a16baaf47bbbb3de1/yt_dlp_ejs-0.8.0.tar.gz"
    sha256 "d5fa1639f63b5c4af8d932495f60689d5370f1a095782c944f7f62a303eb104e"
  end

  def install
    ENV["IMPERSONATE_BUILD_DIR"] = formula_opt_lib("curl-impersonate")
    ENV["IMPERSONATE_LINK_TYPE"] = "dynamic"
    virtualenv_install_with_resources
  end

  test do
    # Verify tubeup attempts to process a URL (expected failure for invalid video)
    output = shell_output("#{bin}/tubeup https://www.youtube.com/watch?v=invalid_video_id --dir #{testpath} 2>&1", 1)
    assert_match "ERROR: [youtube] invalid_vid:", output

    require "utils/linkage"
    curl_cffi = (libexec/Language::Python.site_packages(python3)).glob("curl_cffi/_wrapper.abi3-*.so").first
    curl_impersonate = formula_opt_lib("curl-impersonate")/shared_library("libcurl-impersonate")
    assert Utils.binary_linked_to_library?(curl_cffi, curl_impersonate), "Missing linkage to curl-impersonate!"
  end
end
