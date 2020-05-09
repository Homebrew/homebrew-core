class Salt < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "https://s.saltstack.com/community/"
  url "https://files.pythonhosted.org/packages/74/b7/c7f1ba7a787307c6013f07d506b062bfa2112a583ad58de5f37110e35895/salt-3000.2.tar.gz"
  sha256 "0e33429d094a6109dfed955c4b1c638baee9641eca2f7609bbc4adad21c620d9"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "778c5cb28a0c87e4ed03ad08022da680f3702d781b8f092210c106862bc70cc0" => :catalina
    sha256 "b28fc676d3c42bd671cb04675c070185548434f4751abeb99de53c8fc52d82e2" => :mojave
    sha256 "3b53eba80fe3df81b69be0c02c53c4b00f9af90685e2130a006c6f4f0c99d49b" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "libgit2"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  # Does not support python 3.8: https://github.com/saltstack/salt/issues/55310
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

  # Fix loading of unversioned /usr/lib/libcrypto.dylib, taken from https://github.com/saltstack/salt/pull/56958
  # Remove when merged or https://github.com/saltstack/salt/issues/55084 is fixed
  patch do
    url "https://github.com/saltstack/salt/pull/56958/commits/3dea0e31759b6c2a2c7b46647827a72f7a20dafd.patch?full_index=1"
    sha256 "ddc760333341afb41cbe4083d33b35b8f9a3a0370abd34d6929574d10688de91"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

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
