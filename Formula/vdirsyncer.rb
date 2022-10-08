class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https://github.com/pimutils/vdirsyncer"
  url "https://files.pythonhosted.org/packages/fe/af/b04ca8d53dba17d9f042e9d94b56cf42b23ce8927d84591da1ddd3093cdc/vdirsyncer-0.18.0.tar.gz"
  sha256 "27bc3ed51f774935fbba392915c8c8d4cf639ae51a44b674686b49a1025fc201"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/pimutils/vdirsyncer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bb630b6c7824cc451b615ecc0d66c639fc1aaecc1250067d1b9154c97bc12cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abda18a7cf9b00692be141d7eb6800883b73469a819d15839bb4a304ef1e0c52"
    sha256 cellar: :any_skip_relocation, monterey:       "f4c292e6b0594126b3a685e9cd5b3074eda6074b90d9f61bd0adb44d007a1234"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d65150cd7aa8a31db2103655a3bf4faeab09259c9ddade51f4d2feee6c5949"
    sha256 cellar: :any_skip_relocation, catalina:       "3fc977f2f7f24828432071bc073ea3ef965f8dbe74a9787e104d8ed4765769e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73671af393d13d3d324e0f4eda162dfa471b420c9962fe7cfbbc4d406a73c8d3"
  end

  depends_on "python@3.10"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/22/44/3d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8/click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "click-threading" do
    url "https://files.pythonhosted.org/packages/df/ea/0b20b8e09a6ba1df6defc29479c462437a8e8a3b6f4203fcad8b0a5e3fa3/click-threading-0.5.0.tar.gz"
    sha256 "adcfe623c02a595c107c314072f67a2278fe4eb40b72c0d1a2c903cc78af3439"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/57/d6/20857446a2b81136dd02eed6d198343ce7a045ce8c06d4cb73fd2fee9001/requests-toolbelt-0.10.0.tar.gz"
    sha256 "f695d6207931200b46c8ef6addbc8a921fb5d77cc4cd209c2e7d39293fcd2b30"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"vdirsyncer", "-v", "ERROR", "sync"]
    run_type :interval
    interval 60
    log_path var/"log/vdirsyncer.log"
    error_log_path var/"log/vdirsyncer.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/vdirsyncer/config").write <<~EOS
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
    (testpath/".contacts/a/foo/092a1e3b55.vcf").write <<~EOS
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
    assert_match "Ö φ 風 ض", (testpath/".contacts/b/foo/092a1e3b55.vcf").read
  end
end
