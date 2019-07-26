class Tvnamer < Formula
  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://files.pythonhosted.org/packages/ed/93/f8fbe119844c79ea488332b9ff43702be674332672ea84e9361321985fbd/tvnamer-2.5.tar.gz"
  sha256 "75e38454757c77060ad3782bd071682d6d316de86f9aec1c2042d236f93aec7b"
  head "https://github.com/dbr/tvnamer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f9eaff367dac5d210af44c8a1b768bbd34b5584f755980a9e1b6348c983263f" => :mojave
    sha256 "96c779980beab409c042f22ed2fecfaca0f9d10d3ca2421ec9fdad94e6011363" => :high_sierra
    sha256 "295f7a2e93d3aa599cf23bcf0c90630d0ab5b16508af7b90813c8582623ac085" => :sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/ce/de/2b0cd21915d7c266793cd8bf652c9015f6cb31a8baa5c0f3a8b852596dbf/requests-cache-0.5.0.tar.gz"
    sha256 "6822f788c5ee248995c4bfbd725de2002ad710182ba26a666e85b64981866060"
  end

  resource "tvdb_api" do
    url "https://files.pythonhosted.org/packages/ba/c5/abcff2dd75e63daae3466fffd05a28428e57828f8b878125571a8e8343a8/tvdb_api-2.0.tar.gz"
    sha256 "b1de28a5100121d91b1f6a8ec7e86f2c4bdf48fb22fab3c6fe21e7fb7346bf8f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    raw_file = testpath/"brass.eye.s01e01.avi"
    expected_file = testpath/"Brass Eye - [01x01] - Animals.avi"
    touch raw_file
    system bin/"tvnamer", "-b", raw_file
    assert_predicate expected_file, :exist?
  end
end
