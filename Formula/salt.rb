class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/cc/03/a66a65209aa867c6f8414e5f99a52428400ecc93ab1657102284914a5d52/salt-3001.tar.gz"
  sha256 "5ca60d1b2cc8e63db50995bd8b117914eeaf57c48ce2b3a3731ee57163adf154"
  license "Apache-2.0"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "138cea32de23b64acb9467ab2fe8d9783d47d4a1a947ff83c30effa8aca9aa0b" => :catalina
    sha256 "048bd03fcb35fe5c027c8698bb3f303adc134ba72b529252f12a372ac05940ad" => :mojave
    sha256 "a05afcb8b6a34f2c6e35edc547cacd928bdba93e2843278882f85cd805308c65" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.8"
  depends_on "zeromq"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Homebrew installs optional dependencies: M2Crypto, pygit2

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/d0/c6/33e2df5722e3adf49adc6a2d3c2cdb5a5247236fd8f2063a0c4d058116a1/pygit2-1.2.1.tar.gz"
    sha256 "de9421118a99c79cbba1e512d60e5caed1d63273ce30a0e8d4edef4a2e500387"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Do not install PyObjC since it causes broken linkage
    # https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578
    File.write(buildpath/"pkg/osx/req_pyobjc.txt", "")

    venv = virtualenv_create(libexec, Formula["python@3.8"].bin/"python3.8")
    venv.pip_install resources

    system libexec/"bin/pip", "install", "-v", "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "salt"
    venv.pip_install_and_link buildpath

    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats
    <<~EOS
      Sample configuration files have been placed in #{etc}/saltstack.
      Saltstack will not use these by default.

      Homebrew's installation does not include PyObjC.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salt --version")
  end
end
