class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/3f/c3/316cc75911a9985157df27fbdb7191731e84688101e97d77ea61f22e981d/salt-3001.1.tar.gz"
  sha256 "e9ebb4d92fae8dabf21b8749dc126e4a4048bf8f613f5b1b851fe4b8226b5abc"
  license "Apache-2.0"
  head "https://github.com/saltstack/salt.git", branch: "develop", shallow: false

  livecheck do
    url :stable
  end

  bottle do
    sha256 "7f00834e6d47f0d9b10e65479d3d3a9095bc1636207afdb16f9808f75fb1f71b" => :catalina
    sha256 "3f82a3b5c49d6890334397eec9e8d72841ceee1ebbfdbcf2a33a1a05971355ec" => :mojave
    sha256 "174326324fa9aa283d00204855bfa687964b9c97511e91023b8b8824288c1c82" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/54/1d/15eae71ab444bd88a1d69f19592dcf32b9e3166ecf427dd9243ef0d3b7bc/cffi-1.14.1.tar.gz"
    sha256 "b2a2b0d276a136146e012154baefaea2758ef1f56ae9f4e01c612b0831e0bd2f"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/ff/df/84609ed874b5e6fcd3061a517bf4b6e4d0301f553baf9fa37bef2b509797/M2Crypto-0.36.0.tar.gz"
    sha256 "1542c18e3ee5c01db5031d0b594677536963e3f54ecdf5315aeecb3a595b4dc1"
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
