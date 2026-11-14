class Scdl < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to download music from SoundCloud"
  homepage "https://github.com/scdl-org/scdl"
  url "https://files.pythonhosted.org/packages/30/17/b1d278074f9f6fc25db768b1e104cf71991fff42f0836b0cdcb3d1ae2c81/scdl-3.0.9.tar.gz"
  sha256 "bcd594eab2c1a0d1f40ac0253b262e3b81d8ddc35feb7e89306aa8739ede8d6b"
  license "GPL-2.0-only"
  head "https://github.com/scdl-org/scdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6c6295c78af2cd0d9b0a34d84a7e49fe6b740a8d4fa44fe70583bbfac25910e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "638f36ed6ed4a655cf3fc98f3e96c5d4abb05ca93dc560dfd6bed60e3f13ca4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d763746d92bceaebaeb6d3b11e841b17cd0be86ea3c1b2397dc027e6cd9f6d32"
    sha256 cellar: :any,                 arm64_linux:       "2c4d9334eaecee9d59b6c93cec1c4a278e32192831f284607d870dd706937c69"
    sha256 cellar: :any,                 x86_64_linux:      "9cd7f6af1bd5f1075d77980703078ec60f5d5265ce1fe638d478926397065be9"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "curl-impersonate"
  depends_on "ffmpeg"
  depends_on "python@3.15"

  pypi_packages exclude_packages: %w[certifi cffi]

  resource "curl-cffi" do
    url "https://files.pythonhosted.org/packages/48/5b/89fcfebd3e5e85134147ac99e9f2b2271165fd4d71984fc65da5f17819b7/curl_cffi-0.15.0.tar.gz"
    sha256 "ea0c67652bf6893d34ee0f82c944f37e488f6147e9421bef1771cc6545b02ded"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/55/a0/7ca79796e799a3e782045d29bf052b5cde7439a2bbb17f15ff44f7aacc63/dacite-1.9.2.tar.gz"
    sha256 "6ccc3b299727c7aa17582f0021f6ae14d5de47c7227932c47fec4cdfefd26f09"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/df/f15f80383f152452d8985b36d95cb8751f901a3e0ff4cd27f7e118f168e2/python_dateutil-3.0.0.tar.gz"
    sha256 "7ebcb3c29a92f3ceafe79a7a48a5c45677e9e004bbeec5742ac0bbb00560b7a2"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soundcloud-v2" do
    url "https://files.pythonhosted.org/packages/f1/87/abf8b9f9075c908b4433ee31ca856f9be068dc4315a71e05e9a384ba3a1f/soundcloud_v2-1.7.0.tar.gz"
    sha256 "ce6789f5d7966c38939d52c7fcb326197592c06d68d5585859fa0a4f98c095c9"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/06/13/d2ea252871826205dc4965cb70e6037ab93697fcabf4feda49fe981f6da0/yt_dlp-2026.10.21.tar.gz"
    sha256 "cbf748d7d17cd37647c4b9f07b6c25f24384bfd4361407ee5ec519e753d22539"
  end

  def install
    venv = virtualenv_install_with_resources without: "curl-cffi"
    resource("curl-cffi").stage do
      # TODO: replace following with IMPERSONATE_BUILD_DIR / IMPERSONATE_LINK_TYPE when curl-cffi >= 0.16
      inreplace "scripts/build.py" do |s|
        s.gsub! 'link_type = arch.get("link_type")', 'link_type = "dynamic"'
        s.gsub! 'libdir = Path(arch["libdir"])', "libdir = Path(\"#{formula_opt_lib("curl-impersonate")}\")"
        s.gsub!(/^download_libcurl\(\)$/, "")
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scdl --version").chomp

    output = shell_output("#{bin}/scdl -l https://soundcloud.com/forss/city-ports 2>&1")
    assert_match "[download] Destination: #{testpath}/[290] Forss - City Ports.m4a", output
    assert_match "[download] 100%", output

    require "utils/linkage"
    curl_cffi = (libexec/Language::Python.site_packages(python3)).glob("curl_cffi/_wrapper.abi3-*.so").first
    curl_impersonate = formula_opt_lib("curl-impersonate")/shared_library("libcurl-impersonate")
    assert Utils.binary_linked_to_library?(curl_cffi, curl_impersonate), "Missing linkage to curl-impersonate!"
  end
end
