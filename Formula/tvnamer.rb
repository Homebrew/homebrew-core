class Tvnamer < Formula
  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://github.com/dbr/tvnamer/archive/2.4.tar.gz"
  sha256 "bddaba4b3887ab3b6777932457c8d8f65754b64de9a13b9987869e8e78573bb2"
  revision 1
  head "https://github.com/dbr/tvnamer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f9eaff367dac5d210af44c8a1b768bbd34b5584f755980a9e1b6348c983263f" => :mojave
    sha256 "96c779980beab409c042f22ed2fecfaca0f9d10d3ca2421ec9fdad94e6011363" => :high_sierra
    sha256 "295f7a2e93d3aa599cf23bcf0c90630d0ab5b16508af7b90813c8582623ac085" => :sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/e1/0f/f8d5e939184547b3bdc6128551b831a62832713aa98c2ccdf8c47ecc7f17/certifi-2018.8.24.tar.gz"
    sha256 "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/1a/cf/12349c7113b252d9a0b26d497d3349baeb6c8f293b440e55a00e7fa6e4a4/requests-cache-0.4.13.tar.gz"
    sha256 "fe561ca119879bbcfb51f03a35e35b425e18f338248e59fd5cf2166c77f457a2"
  end

  resource "tvdb_api" do
    url "https://files.pythonhosted.org/packages/ba/c5/abcff2dd75e63daae3466fffd05a28428e57828f8b878125571a8e8343a8/tvdb_api-2.0.tar.gz"
    sha256 "b1de28a5100121d91b1f6a8ec7e86f2c4bdf48fb22fab3c6fe21e7fb7346bf8f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/3c/d2/dc5471622bd200db1cd9319e02e71bc655e9ea27b8e0ce65fc69de0dac15/urllib3-1.23.tar.gz"
    sha256 "a68ac5e15e76e7e5dd2b8f94007233e01effe3e50e8daddf69acfd81cb686baf"
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
