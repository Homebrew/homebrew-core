class Tubeup < Formula
  include Language::Python::Virtualenv

  desc "Use yt-dlp to download video/metadata and upload to the Internet Archive"
  homepage "https://github.com/bibanon/tubeup"
  url "https://files.pythonhosted.org/packages/7e/44/6deb75f6d3a553fe3f8dfbd7c0fdea15f31b67272808efad98303803cca7/tubeup-2026.5.8.tar.gz"
  sha256 "4c75423a429493bddaf78ede0031947938b3eb35435847ee6597b49a4be76ad7"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed547557c67b0fd609a68705b149e9fe3f47ae3b9e789c4ad60117c9cd7f8e10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d8633a7283a30c915d8b0ccc3add9f49568ceea4a4fde45b1abafc696455feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af5673feb1b1af9077d8fd27fae9ba7ca391ab72d77db7b3d4a95611b359e477"
    sha256 cellar: :any,                 arm64_linux:       "ca5806b1bc8d18ebe289b5cf036ba9916392d63fdb2e2ef12ce4bf903b0a2eec"
    sha256 cellar: :any,                 x86_64_linux:      "4674e37e0e3b1821a183fe35fd9182626fe31aa7002bf4811f0abd5b2ff411b8"
  end

  depends_on "node" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.15"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cffi pycparser]

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/82/e1/730125c43e3e331d98e17af3cb310ba526b3f1101b7635ca23d976ebfcf5/curl_cffi-0.16.3.tar.gz"
    sha256 "d15d0c2a35f2d75bec430c28946c2a833f421c85773bdb0795182cc5c515665b"
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
    url "https://files.pythonhosted.org/packages/99/f7/86a84bfdc32c0b3d3fafe90a299a131d2aa661b57cab3d14a506f42405db/internetarchive-5.11.1.tar.gz"
    sha256 "2ae0a529ffe4195c5294a0277e0a9afb83fc00fee5695c6597f65c64e95da44a"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/df/f8/48a6033ebdd5013a58b5a79402eacb15ffb6e208f244c1c17f6f1e3b29c2/jsonpatch-1.35.tar.gz"
    sha256 "679ad08672b4663c7ef1e5f3331d940f5e7786661b9acc1530104be1638e7a4f"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/33/a2/c92f0a7ed439c490d2c8ad712fdb074c311afa4f77870987826a3b1483ba/jsonpointer-3.2.1.tar.gz"
    sha256 "47c846513b3a4ec46eecef1105207fba075e2a3659048e362bd7daff0fc33342"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
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
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/1e/e0/832fa4ca334b766a06933a196066edc3dba37cdb6f14cd98d59bcc69a4b4/yt_dlp-2026.8.19.tar.gz"
    sha256 "9e213e48cea35c66b378e4447903f118f6392a5fa380a2b6d7070ec86f4e0af1"
  end

  resource "yt-dlp-ejs" do
    url "https://files.pythonhosted.org/packages/d3/e6/cceb9530e8f4e5940f6f7822d90e9d94f1b85343329a16baaf47bbbb3de1/yt_dlp_ejs-0.8.0.tar.gz"
    sha256 "d5fa1639f63b5c4af8d932495f60689d5370f1a095782c944f7f62a303eb104e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Verify tubeup attempts to process a URL (expected failure for invalid video)
    output = shell_output("#{bin}/tubeup https://www.youtube.com/watch?v=invalid_video_id --dir #{testpath} 2>&1", 1)
    assert_match "ERROR: [youtube] invalid_vid:", output
  end
end
