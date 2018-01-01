class Tvnamer < Formula
  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://github.com/dbr/tvnamer/archive/2.4.tar.gz"
  sha256 "bddaba4b3887ab3b6777932457c8d8f65754b64de9a13b9987869e8e78573bb2"
  head "https://github.com/dbr/tvnamer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f1ae20737bed54785fce92bbdd67c78f3b20553312d02051f72b8906211d507" => :high_sierra
    sha256 "c1a03bc94b59d7e044445daa9c0037b46230271d457d658aba3e7e55e9291dd0" => :sierra
    sha256 "546b13ef89b777d7076948d993adc9a57c664b2bbc9cb2f429cf042f3d61d165" => :el_capitan
    sha256 "546b13ef89b777d7076948d993adc9a57c664b2bbc9cb2f429cf042f3d61d165" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "tvdb_api" do
    url "https://pypi.python.org/packages/source/t/tvdb_api/tvdb_api-1.10.tar.gz"
    sha256 "308e73a16fc79936f1bf5a91233cce6ba5395b3f908ac159068ce7b1fc410843"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[tvdb_api].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
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
