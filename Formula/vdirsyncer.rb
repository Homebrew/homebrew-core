class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://files.pythonhosted.org/packages/d7/83/1173613bc62b85f8c074b6589072951ad4f7e674d51d8bad875be38bc813/vdirsyncer-0.15.0.tar.gz"
  sha256 "52f7acccab443ce20aca2623b80475f741844929977c08b2f8f11fc9ba2f4a21"
  head "https://github.com/pimutils/vdirsyncer.git"

  bottle do
    sha256 "6114db2c17ab20ea51bda2792b5f750322e6d25a67f181146cfe54995b9edcad" => :sierra
    sha256 "dea2439460c1282fb9d4b775a8630027536a0788c75015e9a1a3c9dd82cf525c" => :el_capitan
    sha256 "2803ab046daf3611dbbde58676322d79c6bf55e637199631921d11919d0e72a8" => :yosemite
  end

  option "with-remotestorage", "Build with support for remote-storage"
  option "with-google", "Build with support for google storage types"

  depends_on :python3

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/a1/e1/2d9bc76838e6e6667fde5814aa25d7feb93d6fa471bf6816daac2596e8b2/atomicwrites-1.1.5.tar.gz"
    sha256 "240831ea22da9ab882b551b31d4225591e5e447a68c5e188db5b89ca1d487585"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/b7/71/d029ea00ede6c1fd307c8d87cd7aac90c1a7ed8dec2ede5dc115e254fade/click-log-0.1.8.tar.gz"
    sha256 "57271008c12e2dc16d413373bedd7fd3ff17c57434e168650dc27dfb9c743392"
  end

  resource "click-threading" do
    url "https://files.pythonhosted.org/packages/66/7f/2afa4041e4b693b317c8bb800cbc87baeb22de9a1c4fac7a89e37276e82c/click-threading-0.4.3.tar.gz"
    sha256 "8f91a9abc8bb40287338e70587bf6043449808a0228c496ff4ef03cdc55b4477"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/ab/bf/2af6b25f880e2d529a524f98837d33b1048a2a15703fc4806185b54e9672/requests-toolbelt-0.7.1.tar.gz"
    sha256 "c3843884269d79e492522f3e9f490917e074c1ddbb80111968970e721fe36eaf"
  end

  if (build.with? "remotestorage") || (build.with? "google")
    resource "oauthlib" do
      url "https://files.pythonhosted.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
      sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
    end

    resource "requests-oauthlib" do
      url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
      sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
    end
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources

    prefix.install "contrib/vdirsyncer.plist"
    inreplace prefix/"vdirsyncer.plist" do |s|
      s.gsub! "@@WORKINGDIRECTORY@@", bin
      s.gsub! "@@VDIRSYNCER@@", bin/name
      s.gsub! "@@SYNCINTERVALL@@", "60"
    end
  end

  def post_install
    inreplace prefix/"vdirsyncer.plist", "@@LOCALE@@", ENV["LC_ALL"] || ENV["LANG"] || "en_US.UTF-8"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<-EOS.undent
      [general]
      status_path = "#{testpath}/.vdirsyncer/status/"
      [pair contacts]
      a = "contacts_a"
      b = "contacts_b"
      collections = ["from a"]
      [storage contacts_a]
      type = "filesystem"
      path = "~/.contacts/a/"
      fileext = ".vcf"
      [storage contacts_b]
      type = "filesystem"
      path = "~/.contacts/b/"
      fileext = ".vcf"
    EOS
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<-EOS.undent
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name Ö φ 風 ض
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath/".contacts/b/foo/").mkpath
    system "#{bin}/vdirsyncer", "discover"
    system "#{bin}/vdirsyncer", "sync"
    assert_match /Ö φ 風 ض/, (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
