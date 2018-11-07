class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.34.tar.gz"
  sha256 "9e034bab4103fbf73ede9a49406a6ea1e7662a03a3e55c5d2bb59fd97c3334ed"
  revision 1
  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "462e935efa5d014f337c4634efee89f3f420903db74439df232f4a1187602bc1" => :mojave
    sha256 "9bc1b73b63ce9e415f3f0cfbf422311ccf3572ad7c0a80c24239f868ec7c1ff3" => :high_sierra
    sha256 "6b030e602596781143cc80253d186a209cfb282dfed2399b141d25917f84b2b3" => :sierra
  end

  depends_on "python"
  depends_on "rtmpdump"

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/7fea932cb012cba8c203d5b46b891167b0f609a6/AdobeHDS.php"
    sha256 "b79e8a4c8544953c39b79a622049c4deced57354adb9697e8c73420c12547229"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e4/ac/a04671e118b57bee87dabca1e0f2d3bda816b7a551036012d0ca24190e71/attrs-18.1.0.tar.gz"
    sha256 "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/54/a6/43be8cf1cc23e3fa208cab04ba2f9c3b7af0233aab32af6b5089122b44cd/lxml-4.2.3.tar.gz"
    sha256 "622f7e40faef13d232fb52003661f2764ce6cdef3edb0a59af7c1559e4cc36d1"
  end

  resource "Mini-AMF" do
    url "https://files.pythonhosted.org/packages/c9/a1/153af98d9ca4ae24fb67ab5cb8e4de8ad44fd991739f32d12b9321d6955d/Mini-AMF-0.9.1.tar.gz"
    sha256 "0c7839dc843b738cdcf5548e85558e7ebd89a9f6fd029751b0bb4d8b0ca4275b"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/55/8c/1a06174a38d1a1a351c31329dcd9653f2a1e16351e53dc87df9263c04ab9/pycryptodomex-3.6.4.tar.gz"
    sha256 "4daabe7c0404e673b9029aa43761c779b9b4df2cbe11ccd94daded6a0acd8808"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz"
    sha256 "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    (resources - [resource("AdobeHDS.php")]).each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("AdobeHDS.php").stage(pkgshare)

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_equal "Traileri: 3 minuuttia-2012-05-30T10:51\n",
                 shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
  end
end
