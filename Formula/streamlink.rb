class Streamlink < Formula
  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://github.com/streamlink/streamlink/releases/download/1.2.0/streamlink-1.2.0.tar.gz"
  sha256 "7aa6e02d914e29fe2e344afd185760b11e46a6a31f9d99f7f9dc87b808812992"

  bottle do
    cellar :any_skip_relocation
    sha256 "199185b9d23b2ec47dea3679e4a60ca66e8ae61097445ce09c04261275960879" => :catalina
    sha256 "9e9a71c03a1cba631f398ae28d1882538598b599d5836a0c847acee2610ba685" => :mojave
    sha256 "fed45686b147aef59d8656625ea75d4e31ed064e62ec5b6efb1d956d750dbeac" => :high_sierra
    sha256 "f3a71304afccc2d8d539dd113e4cbdbfd21a60e73d713326f2a78a7a8a0d4587" => :sierra
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

  resource "iso-639" do
    url "https://files.pythonhosted.org/packages/5a/8d/27969852f4e664525c3d070e44b2b719bc195f4d18c311c52e57bb93614e/iso-639-0.4.5.tar.gz"
    sha256 "dc9cd4b880b898d774c47fe9775167404af8a85dd889d58f9008035109acce49"
  end

  resource "iso3166" do
    url "https://files.pythonhosted.org/packages/0e/ae/0b4ee6f5f3f197b1508f21044f8b18508bc04dd4bc1be98d57d7c720330f/iso3166-1.0.tar.gz"
    sha256 "eaad12d1c5fb9394dc423a13b8084973960a7b392677039ce6fd932aa4a74bab"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/e2/7b/12f76a8bd427ebc54f24a0df6fd776fda48087d6a9a32ae0dbc3341dac3f/pycryptodome-3.8.2.tar.gz"
    sha256 "5bc40f8aa7ba8ca7f833ad2477b9d84e1bfd2630b22a46d9bbd221982f8c3ac0"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/15/ab/35824cfdee1aac662e3298275fa1e6cbedb52126d1785f8977959b769ccf/PySocks-1.7.0.tar.gz"
    sha256 "d9031ea45fdfacbe59a99273e9f0448ddb33c1580fe3831c1b09557c5718977c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd/websocket_client-0.56.0.tar.gz"
    sha256 "1fd5520878b68b84b5748bb30e592b10d0a91529d5383f74f4964e72b297fd3a"
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

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/streamlink", "https://www.youtube.com/watch?v=he2a4xK8ctk", "360p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MP4 v2", shell_output("file video.mp4")
  end
end
