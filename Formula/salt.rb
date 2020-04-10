class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/b5/7b/e591ad97f038f32298ee6303414767cdd8df811c9daf5b48c37afe9610c3/salt-3000.1.tar.gz"
  sha256 "5ad18044b4a47690d09c3ebc842a64d58144d63f40019e867683377dbf337aab"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "3c1f68e1dfd495bd0eff8c09be38273c7318e08e591a2610bb454e7f768b1192" => :catalina
    sha256 "2113ac5669fd5883e342b751f7d1f67264055524fca11fa48b741069ca621e8d" => :mojave
    sha256 "b2bf7130f4ad792e0a14af237b0536c8e9f3642ea20521153fa35155fd7dfb6b" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python"
  depends_on "zeromq"

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
    url "https://files.pythonhosted.org/packages/a5/97/49cb02500d851a172c287cafe04eca864771d99ace6a81967d9a99f0c39e/pygit2-1.2.0.tar.gz"
    sha256 "f991347f5b11589ac8dc5a3c8257a514cf802545b75c11133a43ae9f76388278"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Workaround for https://github.com/saltstack/salt/issues/55084
    # Remove when fixed
    inreplace "salt/utils/rsax931.py",
              "lib = find_library('crypto')",
              "lib = '#{Formula["openssl@1.1"].opt_lib}/libcrypto.dylib'"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Do not install PyObjC since it causes broken linkage
    # https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578
    File.write(buildpath/"pkg/osx/req_pyobjc.txt", "")

    venv = virtualenv_create(libexec, "python3")
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
