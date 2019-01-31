class Streamlink < Formula
  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://github.com/streamlink/streamlink/releases/download/1.0.0/streamlink-1.0.0.tar.gz"
  sha256 "b0a355add636c37531efc76e784d1c9e390f3d171f039e07a6be717eb956bfc7"

  bottle do
    cellar :any
    sha256 "c4a96191f6db7355541deb480c22d9257536902b2f734917efa2ceab50410a45" => :mojave
    sha256 "c22ef0ffd0a93c276ea06b57ea98fab25ed7fd2faeabeee46fe50802382c56cb" => :high_sierra
    sha256 "bbc2bf85d06976e7bdee912a2e8c3f3ed9509c726eaebb1f11eedfce7fd6f760" => :sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
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
    url "https://files.pythonhosted.org/packages/f2/f6/985e5b174786e93aff77ec055a4b7ba55ebc95a3f8b5880f845d7bbd253e/iso3166-0.9.tar.gz"
    sha256 "545a9dbf57b56acfa0dad7978cae2bdd8e0ef4c48cd8aab50c335f0d46eda042"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/c7/ff/1ca71a40eb69c89778396a30d399639d41473b09c36aff2b700d80dd94b9/pycryptodome-3.7.3.tar.gz"
    sha256 "1a222250e43f3c659b4ebd5df3e11c2f112aab6aef58e38af55ef5678b9f0636"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz"
    sha256 "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
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
    system "#{bin}/streamlink", "https://www.youtube.com/watch?v=he2a4xK8ctk", "144p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MPEG v4 system, 3GPP", shell_output("file video.mp4")
  end
end
